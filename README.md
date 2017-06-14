## Setup

### macOS

```
brew install elixir node@6 yarn
```

## Running (Development)

The code is divided into separate backend and frontend packages.

The backend is written in [Elixir](http://elixir-lang.org) / 
[Phoenix](http://phoenixframework.org) and the frontend in 
[Ember](http://emberjs.com)

They are run separately. When you do your development you are interacting
with the ember webserver. Ember knows how to proxy the API requests over
to elixir when needed.

When running in production we build all the ember code and bundle it
with the backend release.

To start the servers

```
cd backend
mix phoenix.server
cd ../frontend
ember s --proxy http://localhost:4000
```

If you need to create a database for development you can

```
cd backend
mix ecto.create
mix ecto.migrate
```



