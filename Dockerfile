FROM elixir:latest

RUN apt-get update -qq && apt-get install -y libpq-dev && apt-get install -y build-essential inotify-tools erlang-dev erlang-parsetools apt-transport-https ca-certificates && apt-get update && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" |  tee /etc/apt/sources.list.d/yarn.list &&  apt-get update &&  apt-get install --no-install-recommends yarn
RUN mix local.hex --force && mix local.rebar --force
RUN mix archive.install hex phx_new 1.4.0 --force

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && apt-get install -y nodejs

WORKDIR /app

# Next commands aren't working for a while
#CMD mix deps.get
#
#CMD MIX_ENV=dev mix ecto.setup
#CMD MIX_ENV=test mix ecto.setup