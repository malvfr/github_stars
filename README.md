# GithubStars

# REST specifications

The REST specifications are OpenAPI compatible, you can find the Swagger UI at: _yourhost:4000/api/swagger/index.html_

# Running the application

### Run on docker

To setup the application environment, use docker-compose to quickly bootstrap and run the Phoenix server.

The command below will spin up the server and a local database

```bash
docker-compose up
```

After the server and the application run, you can access the Application through "http://localhost:4000/api"

### Run on local environment

Configure the environment variables for a running Postgres instance

```
  DB_USER: user
  DB_PASS: pass
  DB_DATABASE: database
  DB_HOSTNAME: hostname
```

You also need to add your github authentication bearer token as an environment variable

```
  GITHUB_AUTH: "Bearer ..."
```

### Install dependencies

```bash
mix local.hex --force
mix local.rebar --force
mix deps.get
```

### Run the server

```bash
mix phx.server
```

# Tasks

For additional information about the project, you can check the tasks below on a terminal.

Runs the application tests

```bash
mix test
```

Runs the local linter

```bash
mix credo
```

Generates coverage report

```bash
mix coveralls.html
```

Generates the swagger bindings

```bash
mix phx.swagger.generate
```
