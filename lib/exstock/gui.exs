defmodule Exstock.Portfolio do
  @behaviour Ratatouille.App

  alias Ratatouille.Runtime.Subscription

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
  @up key(:arrow_up)
  @down key(:arrow_down)
  @left key(:arrow_left)
  @right key(:arrow_right)
  @arrows [@up, @down, @left, @right]

  def init(_context) do
    %{
      local_time: :calendar.local_time(),
      search_term: "",
      results: [],
      wallet: [],
      notification: "",
      errors: "",
      prefered_asset: "AAPL",
      insights: %{}
    }
  end

  def update(model, message) do
    case message do
      {:event, %{key: @enter}} ->
        Exstock.Worker.add_quote(model.search_term)
        quotes = Exstock.Worker.get_quote()

        Map.put(model, :results, Enum.concat([quotes, model.results]))

      {:event, %{key: key}} when key in @delete_keys ->
        current = String.slice(model.search_term, 0..-2)
        Map.put(model, :search_term, current)

      {:event, %{key: @spacebar}} ->
        Map.put(model, :search_term, model.search_term <> " ")

      {:event, %{ch: ch}} when ch > 0 ->
        Map.put(model, :search_term, model.search_term <> <<ch::utf8>>)

      {:event, %{key: @ctrl_l}} ->
        %{model | results: [], search_term: ""}

      :tick ->
        %{
          model
          | local_time: :calendar.local_time()
        }

      :longer_tick ->
        %{model | notification: Exstock.Alert.retrieve()}

      _ ->
        model
    end
  end

  def subscribe(_model) do
    Subscription.batch([
      Subscription.interval(1000, :tick),
      Subscription.interval(5000, :longer_tick)
    ])
  end

  defp formatted_datetime(local_time) do
    {:ok, dt} = NaiveDateTime.from_erl(local_time)
    Calendar.strftime(dt, "%Y-%m-%d %H:%M:%S %p")
  end

  defp render_search_row(model) do
    row =
      for item <- model.results do
        table_row do
          table_cell(content: number_to_currency(item.high), color: :green)
          table_cell(content: number_to_currency(item.low), color: :red)
          table_cell(content: number_to_currency(item.price))
          table_cell(content: to_string(item.name))
          table_cell(content: to_string(item.type))
        end
      end

    row
  end

  defp render_row(model) do
    rows =
      for item <- model.wallet do
        {:ok, stock} = Exstock.Query.quote(item)

        table_row do
          table_cell(content: number_to_currency(stock.high), color: :green)
          table_cell(content: number_to_currency(stock.low), color: :red)
          table_cell(content: number_to_currency(stock.price))
          table_cell(content: to_string(stock.name))
          table_cell(content: to_string(stock.type))
        end
      end

    rows
  end

  defp render_insights(%{company: company, stats: stats} = insights) do
    tree do
      tree_node(content: "Stats", color: :blue) do
        tree_node(content: "Sector: #{company["sectorInfo"]}")

        tree_node(content: "Stop loss: #{stats["keyTechnicals"]["stopLoss"]}")

        tree_node(content: "Support/Resistance at #{stats["keyTechnicals"]["support"]}")

        tree_node(content: "Symptoms by - #{stats["technicalEvents"]["provider"]}") do
          tree_node(content: "short - #{stats["technicalEvents"]["shortTerm"]}")

          tree_node(content: "mid - #{stats["technicalEvents"]["midTerm"]}")

          tree_node(content: "long - #{stats["technicalEvents"]["longTerm"]}")
        end
      end
    end
  end

  defp render_insights(%{}) do
    label(content: "-")
  end

  def render(model) do
    top_bar =
      bar do
        label do
          text(
            content: "Exstock 0.0.1 (CTRL-d to quit)",
            padding: 5,
            attributes: [:bold]
          )
        end
      end

    view(top_bar: top_bar) do
      label(content: "🕗  - " <> formatted_datetime(model.local_time))
      label(content: "\n")

      row do
        column size: 12 do
          panel title: "Search stock/crypto (Ctrl-L to clear)" do
            label(content: model.search_term <> "▌")

            if length(model.results) > 0 do
              table do
                table_row do
                  table_cell(content: "high", attributes: [:bold, :underline])
                  table_cell(content: "low", attributes: [:bold, :underline])
                  table_cell(content: "price", attributes: [:bold, :underline])
                  table_cell(content: "name", attributes: [:bold, :underline])
                  table_cell(content: "type", attributes: [:bold, :underline])
                end

                render_search_row(model)
              end
            end
          end
        end
      end

      row do
        column size: 8 do
          panel title: "Wallet", color: :green do
            label(content: "My Wallet")

            table do
              table_row do
                table_cell(content: "high", attributes: [:bold, :underline])
                table_cell(content: "low", attributes: [:bold, :underline])
                table_cell(content: "price", attributes: [:bold, :underline])
                table_cell(content: "name", attributes: [:bold, :underline])
                table_cell(content: "type", attributes: [:bold, :underline])
              end

              if length(model.wallet) > 0 do
                render_row(model)
              end
            end
          end
        end

        column size: 4 do
          panel title: "Notifications", color: :blue do
            label(content: model.notification)
          end
        end
      end

      row do
        column size: 8 do
          panel title: "🔍 Insights for: " <> model.prefered_asset, color: :magenta do
            render_insights(model.insights)
          end
        end
      end
    end
  end
end

Exstock.Supervisor.start_link()
Exstock.Scheduler.quote("AAPL")

Ratatouille.run(Exstock.Portfolio,
  quit_events: [
    {:key, Ratatouille.Constants.key(:ctrl_d)}
  ]
)
