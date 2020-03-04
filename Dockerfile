FROM elixir:1.10 as build

WORKDIR /app

RUN mix do local.hex --if-missing --force, local.rebar --force
COPY backend/config/ /app/config/
COPY backend/mix.exs /app/
COPY backend/mix.* /app/
COPY version.txt /

ENV MIX_ENV=prod
RUN mix do deps.get --only $MIX_ENV, deps.compile

RUN apt-get update -y
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_10.x  | bash -
RUN apt-get -y install nodejs

COPY ./backend /app/

RUN mix deps.get --only prod
RUN npm install --prefix ./assets
ENV PATH=./node_modules/.bin:$PATH
RUN MIX_ENV=prod mix compile
RUN npm run deploy --prefix assets
RUN mix phx.digest

RUN MIX_ENV=prod mix release

FROM registry.git.uiowa.edu:5005/ccom/research/aptamer-scripts:latest as run

EXPOSE 4000
ENV PORT=4000 \
    MIX_ENV=prod \
    SHELL=/bin/bash

WORKDIR /app
COPY --from=build /app/_build/prod/rel/aptamer .

CMD ["./bin/aptamer", "start"]
