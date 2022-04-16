defmodule Exstock.Portfolio do
  @behaviour Ratatouille.App

  alias Ratatouille.Runtime.Subscription

  import Ratatouille.View
  import Ratatouille.Constants, only: [key: 1]

  @spacebar key(:space)

  @delete_keys [
    key(:delete),
    key(:backspace),
    key(:backspace2)
  ]

  @up key(:arrow_up)
  @down key(:arrow_down)
  @left key(:arrow_left)
  @right key(:arrow_right)
  @arrows [@up, @down, @left, @right]

  def init(_context) do
    %{
      local_time: :calendar.local_time(),
      search_term: ""
    }
  end

  def update(model, message) do
    case message do
      {:event, %{key: :enter}} ->
        IO.inspect("hi")

      {:event, %{key: key}} when key in @delete_keys ->
        current = String.slice(model.search_term, 0..-2)
        Map.put(model, :search_term, current)

      {:event, %{key: @spacebar}} ->
        Map.put(model, :search_term, model.search_term <> " ")

      {:event, %{ch: ch}} when ch > 0 ->
        Map.put(model, :search_term, model.search_term <> <<ch::utf8>>)

      :tick ->
        %{
          model
          | local_time: :calendar.local_time()
        }

      _ ->
        model
    end
  end

  def subscribe(_model) do
    Subscription.interval(1000, :tick)
  end

  defp formatted_datetime(local_time) do
    {:ok, dt} = NaiveDateTime.from_erl(local_time)
    Calendar.strftime(dt, "%Y-%m-%d %H:%M:%S %p")
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
          panel title: "Search stock/crypto" do
            label(content: model.search_term <> "▌")
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
                table_cell(content: "close_price", attributes: [:bold, :underline])
                table_cell(content: "symbol", attributes: [:bold, :underline])
                table_cell(content: "type", attributes: [:bold, :underline])
              end

              table_row do
                table_cell(content: "171.27", color: :green)
                table_cell(content: "165.05", color: :red)
                table_cell(content: "165.06")
                table_cell(content: "AAPL")
                table_cell(content: "Stock")
              end

              table_row do
                table_cell(content: "1012.71", color: :green)
                table_cell(content: "982.25", color: :red)
                table_cell(content: "989.5")
                table_cell(content: "TSLA")
                table_cell(content: "Stock")
              end

              table_row do
                table_cell(content: "3117.94", color: :green)
                table_cell(content: "3029.435", color: :red)
                table_cell(content: "3034.0")
                table_cell(content: "AMZN")
                table_cell(content: "Stock")
              end
            end
          end
        end

        column size: 4 do
          panel title: "Notifications", color: :blue do
            label(content: "-")
          end
        end
      end

      row do
        column size: 4 do
          panel title: "Insights", color: :cyan do
            label(content: "-")
          end
        end
      end
    end
  end
end

Ratatouille.run(Exstock.Portfolio,
  quit_events: [
    {:key, Ratatouille.Constants.key(:ctrl_d)}
  ]
)
