# Aptamer [![Build Status](https://travis-ci.org/ui-icts/aptamer-web.svg?branch=master)](https://travis-ci.org/ui-icts/aptamer-web)

## Setup

### macOS

```
brew install elixir node@6 yarn postgresql
npm install -g ember-cli
```

## Development

The code is divided into separate backend and frontend packages.

The backend is written in [Elixir](http://elixir-lang.org) / 
[Phoenix](http://phoenixframework.org) and the frontend in 
[Ember](http://emberjs.com)

They are run separately. When you do your development you are interacting
with the ember webserver. Ember knows how to proxy the API requests over
to elixir when needed.

When running in production we build all the ember code and bundle it
with the backend release.

To get the code

```
mkdir -p ~/icts/aptamer
cd ~/icts/aptamer
# Or fork this and clone from your own
git clone git@github.uiowa.edu:cortman/aptamer-web.git web
git clone git@github.com:ui-icts/aptamer.git scripts
```

There are some other setup steps in the scripts repo.

For now, focus on the web.

```
cd web
```

To start the servers
*Note: After you run `mix phoenix.server`, you may be propmpted to allow the download (or run 
commands) of other dependencies. Go ahead and say yes to those prompts.*

```
cd backend
mix phoenix.server
cd ..
yarn install
cd frontend
ember s --proxy http://localhost:4000
```

If you receiver this error

```
psql: FATAL:  role "postgres" does not exist
```

Try creating a user by running this command (replacing '9.6.4' with your version of postgres):

```
/usr/local/Cellar/postgresql/9.6.4/bin/createuser -s postgres
# Or if that doesn't fix it
brew cask install postgres
```

If you need to create a database for development you can

```
cd backend
mix ecto.create
mix ecto.migrate
```

## Production

### Database

```
createdb --lc-collate='en_US.utf8' \
  --lc-ctype='en_US.utf8' \
  --encoding='UTF8' \
  --template=template0 \
  --owner=aptamer \
  aptamer2

```

### Habitat

I split install into two steps, you should probably look at the file before you pipe it into
sudo

```
curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh
cat install.sh | sudo bash
```

Once habitat is installed on the server you need to install two
packages

```
sudo hab pkg install chrisortman/aptamer-scripts
sudo hab pkg install chrisortman/aptamer-web
sudo hab svc load chrisortman/aptamer-web --strategy at-once
```

The service can be configured by creating a configuration file
like the one below

```
port = 4002
database_name = "aptamer_prod"
database_user = "postgres"
database_password = "postgres"
database_port = 5432
database_host = "localhost"
```

And then running 

```
sudo hab config apply aptamer-web.default 1 mine.config
```

You must create the database before running the service.
