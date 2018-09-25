# BinanceScrapper

change config 

config/prod.secret.exs file

```
config :binance,
  api_key: "xxx",
  secret_key: "xxx"

config :binance_scrapper, BinanceScrapperWeb.Endpoint,
  secret_key_base: "PT5WcKoWzKkCxIaajmzCSlpmkhel/LewDFZ+f3uj3+ECZmtmRjWo/SK76pbSjqaf"

config :nostrum,
  token: "xxx" # your bot token
```

# Configure your database
config :binance_scrapper, BinanceScrapper.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "binance_scrapper_prod",
  pool_size: 15


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

