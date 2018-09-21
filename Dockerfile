FROM elixir:1.7.2 as builder
ENV MIX_ENV="test"
COPY . /app
WORKDIR /app
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix test

FROM elixir:1.7.2
ENV CONSUMER_URI=wss://streaming.smartcolumbusos.com/socket/websocketx
COPY . /app
WORKDIR /app
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod && \
    mix compile
CMD ["mix", "run"]
