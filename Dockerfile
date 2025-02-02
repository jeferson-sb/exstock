FROM elixir:1.18.0-slim

WORKDIR /app

COPY mix.exs mix.lock ./

ENV MIX_ENV=prod

RUN mix local.hex --force
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

