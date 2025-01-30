# Tracker

This is the core Tracker component used to keep track of stock market prices by usign a Oban periodic job based on your watchlist.
It make use of two external financial APIs: alphavantage (primary) and twelvedata (secondary). 
Be aware that although these services have a free tier, you will need to take of your daily quota limit.

It also allows you to persist portfolio, wallet, assets and watchlist via repositories.

## Quick setup

Make sure to set up the environment variables in your `config/dev.exs` file.

```bash
mix deps.get
mix ecto.create
mix ecto.migrate
```

## Usage

```bash
iex> Tracker.Watchlist.Repo.all
iex> Tracker.Wallet.Repo.all
iex> p = Tracker.Portfolio.Repo.create(%Tracker.Portfolio{name: "My portfolio"})
```


## Testing

```bash
mix test
```

## Formatting

```bash
mix format
```
