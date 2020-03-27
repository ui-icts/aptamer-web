FROM elixir:1.10 as build

WORKDIR /app

RUN apt-get update -y
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_10.x  | bash -
RUN apt-get -y install nodejs

RUN mix do local.hex --if-missing --force, local.rebar --force

COPY backend/config/ /app/config/
COPY backend/mix.exs /app/
COPY backend/mix.* /app/
COPY version.txt /

ENV MIX_ENV=prod
ENV PATH=./node_modules/.bin:$PATH

RUN mix do deps.get --only $MIX_ENV, deps.compile

COPY ./backend /app/

RUN mix deps.get --only prod
RUN npm install --prefix ./assets
RUN mix compile
RUN npm run deploy --prefix assets
RUN mix phx.digest

RUN mix release

FROM elixir:1.10-slim as run

EXPOSE 4000
ENV PORT=4000 \
    MIX_ENV=prod \
    SHELL=/bin/bash

WORKDIR /app
COPY --from=build /app/_build/prod/rel/aptamer .

CMD ["./bin/aptamer", "start"]
