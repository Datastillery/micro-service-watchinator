FROM elixir:1.7.2 as builder
ENV MIX_ENV="test"
COPY . /app
WORKDIR /app
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix test && \
    mix credo
RUN MIX_ENV=prod mix release


FROM elixir:1.7.2
ENV CONSUMER_URI=wss://streaming.smartcolumbusos.com/socket/websocket
ENV MIX_ENV="prod"
WORKDIR /app
COPY --from=builder /app/_build/prod/rel/micro_service_watchinator/ .
CMD ["bin/micro_service_watchinator", "foreground"]
