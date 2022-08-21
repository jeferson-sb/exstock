FROM elixir:1.13.3-slim

WORKDIR /app

COPY mix.exs mix.lock ./

ENV MIX_ENV=prod

RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

