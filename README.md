# MakeWordBot

This is game bot for telegram channels and dialogs.
Bot will be written on elixir + phoenix framework as home pet project.

# Installation

* Install dependencies with `mix deps.get`
* Create copy of secrets files and fill your values for them:

```
$ cp config/telegram.example.exs config/telegram.secret.exs
$ cp config/prod.example.exs config/prod.secret.ext
```

These files will be outside of git repo, so will be sure you are stored them correctly.
Change value of your telegram token in `config/telegram.secret.exs`.
Also change database config in `config/dev.exs` if you want run bot in development environment.
Or  change database config in `config/prod.sescret.exs` if you want run bot in production.

* Init database with `mix ecto.setup`. If you want use your own vocabulary, replace file
`priv/repo/vocabulary.txt` with your own vocabulary (each word - one line). Migration ommits words with noncharacter symbols like ".", " "... and now is working only for Cyrylic vocabularies.

* Run bot with `mix phx.server` for development environment
