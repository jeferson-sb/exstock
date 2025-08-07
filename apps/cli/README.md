# Cli

The CLI is a command line interface for consuming the Tracker core.
It manages by parsing arguments and handling the apropriate commands while
prompt the user for input when needed.

## Quick setup

> [!WARNING]  
> To use the database make sure you had already setup Tracker.

```bash
cd exstock
mix deps.get
```

## Usage

```bash
iex -S mix
```

```bash
iex> Cli.main ["-h"]
iex> Cli.main ["wallet:list"]
iex> Cli.main ["watchlist:list"]
iex> Cli.main ["portfolio:create"]
iex> Cli.main ["wallet:create"]
```
