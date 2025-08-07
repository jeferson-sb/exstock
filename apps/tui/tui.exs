defmodule Tui do
  @behaviour Ratatouille.App

  alias Ratatouille.Runtime.Subscription
  alias Ratatouille.Runtime.Command

  import Ratatouille.View
  import Ratatouille.Constants, only: [key: 1]
  import Number.Currency

  @spacebar key(:space)
  @enter key(:enter)

  @delete_keys [
    key(:delete),
    key(:backspace),
    key(:backspace2)
  ]

  @ctrl_l Ratatouille.Constants.key(:ctrl_l)

  def init(_) do
    model = %{
      local_time: :calendar.local_time(),
      search_term: "",
      search_results: %{},
      error: "",
      watchlist: [],
      wallets: Tracker.Wallet.Repo.all,
      exchange_rates: [],
    }

    {model, update_cmd(model)}
  end

  defp update_cmd(_model) do
    Command.batch([
      Command.new(fn ->
        case Watchlist.Service.execute() do
          {:error, reason} -> {:error, reason}
          watchlist -> watchlist
        end
      end, :load_watchlist),
      Command.new(fn ->
        case ExchangeList.Service.execute() do
          {:error, reason} -> {:error, reason}
          rates -> rates
        end
      end, :load_exchange_rates)
    ])
  end

  defp render_watchlist_row(model) do
    rows =
      for item <- model.watchlist do
        table_row do
          table_cell(content: item.symbol)
          table_cell(content: Helpers.Watchlist.format_condition(item.condition))
          table_cell(content: Helpers.NumberFormat.format_currency(elem(item.values, 0)))
          table_cell(content: Helpers.NumberFormat.format_currency(elem(item.values, 1)))
          table_cell(content: Helpers.NumberFormat.format_currency(elem(item.values, 2)))
        end
      end

    rows
  end

  defp render_wallet_row(model) do
    rows =
      for item <- model.wallets do
        table_row do
          table_cell(content: item.name)
        end
      end

    rows
  end

  defp render_exchange_rates_row(model) do
    rows =
      for item <- model.exchange_rates do
        table_row do
          table_cell(content: item["symbol"])
          table_cell(content: Helpers.NumberFormat.format_currency(item["rate"]))
        end
      end

    rows
  end

  defp render_search_row(%{stats: stats, company: company}) do
    tree do
      tree_node(content: "Market", color: :blue) do
        tree_node(content: "Name: #{stats["name"]}")
        tree_node(content: "Volume: #{Helpers.HumanFormat.format_human(stats["average_volume"])}")
        tree_node(content: "Close: #{Helpers.NumberFormat.format_currency(stats["close"])}")
        tree_node(content: "Open: #{Helpers.NumberFormat.format_currency(stats["open"])}")
        tree_node(content: "52 Week: #{stats["fifty_two_week"]["low"]} -> #{stats["fifty_two_week"]["high"]}")

        tree_node(content: "Company", color: :red, background: :black) do
          tree_node(content: "Industry -  #{company["Industry"]}")
          tree_node(content: "Dividend Yield % - #{company["DividendYield"]}")
          tree_node(content: "Revenue - #{Helpers.HumanFormat.format_human(company["RevenueTTM"])}")
          tree_node(content: "Market Cap - #{Helpers.HumanFormat.format_human(company["MarketCapitalization"])}")
          tree_node(content: "EBITDA - #{Helpers.HumanFormat.format_human(company["EBITDA"])}")
        end
      end
    end
  end

  def subscribe(_model) do
    Subscription.batch([
      Subscription.interval(1000, :tick),
    ])
  end

  def update(model, msg) do
    case msg do
      {:event, %{key: @enter}} ->
        if model.search_term == "" do
          Map.put(model, :search_results, %{})
        else
          {model, search_results} =
            case Tracker.Query.get_latest_symbol(model.search_term) do
              {:ok, stats} ->
                {model, Map.put(model.search_results, :stats, stats)}
              {:error, message} ->
                {Map.put(model, :error, message), model.search_results}
            end

          {model, search_results} =
            case Tracker.Query.get_company_stats(model.search_term) do
              {:ok, company} ->
                {model, Map.put(search_results, :company, company)}
              {:error, message} ->
                {Map.put(model, :error, message), search_results}
            end

          Map.put(model, :search_results, search_results)
        end


      {:event, %{key: key}} when key in @delete_keys ->
        current = String.slice(model.search_term, 0..-2//1)
        Map.put(model, :search_term, current)

      {:event, %{key: @spacebar}} ->
        Map.put(model, :search_term, model.search_term <> " ")

      {:event, %{ch: ch}} when ch > 0 ->
        Map.put(model, :search_term, model.search_term <> <<ch::utf8>>)

      {:event, %{key: @ctrl_l}} ->
        %{model | search_results: %{}, search_term: ""}

      {:load_watchlist, {:error, message}} ->
        %{model | error: message, watchlist: [] }

      {:load_watchlist, content} ->
        %{model | watchlist: content }

      {:load_exchange_rates, {:error, message}} ->
        %{model | error: message, exchange_rates: []}

      {:load_exchange_rates, rates} ->
        %{model | exchange_rates: rates}


      :tick ->
        %{model | local_time: :calendar.local_time() }

      _ -> model
    end
  end

  def render(model) do
    top_bar =
      bar do
        label do
          text(
            content: "Exstock 1.0.0 (CTRL-Q to quit)",
            attributes: [:bold]
          )
          text(content: " 🕗 " <> " " <> Helpers.DatetimeFormat.format_datetime(model.local_time))
        end
      end

    view(top_bar: top_bar) do
      if model.error != "" do
        label(content: "⚠️ ERROR: " <> model.error, color: :red)
      end
      label(content: "\n")

      row do
        column size: 12 do
          panel title: "🔍\t Search stock/crypto (Ctrl-L to clear)" do
            label(content: model.search_term <> "▌")

            if length(Map.keys(model.search_results)) > 0 do
              render_search_row(model.search_results)
            end
          end
        end
      end

      row do
        column size: 9 do
          panel title: "👀\t Watchlist", color: :green do
            table do
              table_row do
                table_cell(content: "Stock/Crypto", attributes: [:bold, :underline])
                table_cell(content: "Condition", attributes: [:bold, :underline])
                table_cell(content: "High", attributes: [:bold, :underline])
                table_cell(content: "Low", attributes: [:bold, :underline])
                table_cell(content: "Close (today)", attributes: [:bold, :underline])
              end


              if length(model.watchlist) > 0 do
                render_watchlist_row(model)
              end
            end
          end
        end

        column size: 3 do
          panel title: "👝\t Wallets", color: :blue do
            table do
              render_wallet_row(model)
            end
          end
        end
      end

      row do
        column size: 9 do end
        column size: 3 do
          panel title: "💵\t Exchange Rates", color: :red do
            table do
              render_exchange_rates_row(model)
            end
          end
        end
      end

    end
  end
end

Ratatouille.run(Tui, quit_events: [
  {:key, Ratatouille.Constants.key(:ctrl_q)}
])
