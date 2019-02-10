# MakeWordBot

This is game bot for telegram channels and dialogs.
Bot is written on Elixir + Phoenix as educational PET project.

## Installation (for dev)

Checkout this repository

```bash
git clone https://github.com/nulleof/make-word-bot.git
cd make-word-bot
```

Create config files from template, and change values to yours

```bash
cp config/config.example.exs config/dev.secret.exs
cp config/config.example.exs config/prod.secret.exs
cp config/config.example.exs config/test.secret.exs
cp config/telegram.example.exs config/telegram.secret.exs
```

Also edit your `docker-compose.yml` file by setting appropriate base username and password

Init ssl certificates with
```
openssl req -newkey rsa:2048 -sha256 -nodes -keyout priv/keys/dev.key -x509 -days 365 -out priv/keys/dev.pem -subj "/C=US/ST=New York/L=Brooklyn/O=Example Brooklyn Company/CN=YOURDOMAIN.EXAMPLE"
```

### Install dependencies

Install deps
```bash
docker-compose run web mix deps.get
```

Init ecto databases
```bash
docker-compose run web mix ecto.setup
docker-compose run test mix ecto.setup
```

After that your project folder contains `_build` and `deps` directories. Note if you use Docker not under root, you better to change it's ownership
```bash
sudo chown -R $USER:$USER .
```

NB: I think there will be other files in `_build` folder which owned by root after start app development.

## Run

Run container with, you must have installed `docker` and `docker-compose` (google it). If you run not under root user, it must be in `docker` usergroup (look here https://docs.docker.com/install/linux/linux-postinstall/)
```bash
docker-compose run web
```

Or create image and connect later (not tested)
```bash
docker-compose up -d web && docker attach make_word_bot
```

Or connect to bash of container (if you wasn't attachec)
```bash
docker exec -ti make_word_bot /bin/bash
```

Or see logs (not tested)
```bash
docker-compose logs
```

## Tests

To perform all tests run
```bash
docker-compose run test
```

To perform one test run
```bash
docker-compose run test mix test test/make-word-bot/utils_test.exs
```

## Notes

You can commit supervised InitWebhook in application.ex and set webhook path with curl command yourself:

```
curl https://api.telegram.org/bot<token>/setWebhook \
    -F "url=yoururl" \
    -F "certificate=@pathToPubKey.der"
```
