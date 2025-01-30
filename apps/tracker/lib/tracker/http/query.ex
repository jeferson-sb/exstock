defmodule Tracker.Query do
  @primary_apiurl Application.compile_env(:tracker, :primary_finance_api_url)
  @primary_apikey Application.compile_env(:tracker, :primary_finance_api_key)
  @secondary_apiurl Application.compile_env(:tracker, :secondary_finance_api_url)
  @secondary_apikey Application.compile_env(:tracker, :secondary_finance_api_key)
  @country "US"

  def search_symbol(symbol) do
    HTTPoison.get!(
      "#{@primary_apiurl}/symbol_search?symbol=#{symbol}&api_token=#{@primary_apikey}"
    )
    |> parse_response()
  end

  def get_latest_symbol(symbol) do
    HTTPoison.get!(
      "#{@primary_apiurl}/quote?symbol=#{symbol}&country=#{@country}&interval=30min&apikey=#{@primary_apikey}"
    )
    |> parse_response()
  end

  def get_currency_conversion(from, to, amount) do
    HTTPoison.get!(
      "#{@primary_apiurl}/currency_conversion?symbol=#{from}/#{to}&amount=#{amount}&apikey=#{@primary_apikey}"
    )
    |> parse_response()
  end

  def get_exchange_rate(from, to) do
    HTTPoison.get!(
      "#{@primary_apiurl}/exchange_rate?symbol=#{from}/#{to}&apikey=#{@primary_apikey}"
    )
    |> parse_response()
  end

  def eod_price(symbol) do
    HTTPoison.get!(
      "#{@primary_apiurl}/eod?symbol=#{symbol}&country=#{@country}&apikey=#{@primary_apikey}"
    )
    |> parse_response()
  end

  def get_paid_dividends(symbol) do
    HTTPoison.get!(
      "#{@secondary_apiurl}/query?function=DIVIDENDS&symbol=#{symbol}&apikey=#{@secondary_apikey}"
    )
    |> parse_response()
  end

  def get_company_stats(symbol) do
    HTTPoison.get!(
      "#{@secondary_apiurl}/query?function=OVERVIEW&symbol=#{symbol}&apikey=#{@secondary_apikey}"
    )
    |> parse_response()
  end

  defp parse_response(%HTTPoison.Response{status_code: 429}) do
    {:error, "Too many requests"}
  end

  defp parse_response(%HTTPoison.Response{status_code: 403}) do
    {:error, "Forbidden"}
  end

  defp parse_response(%HTTPoison.Response{body: body, status_code: 200}) do
    case Jason.decode(body) do
      {:ok, %{"data" => [], "meta" => %{"requested" => 1, "returned" => 0}}} ->
        {:error, "Symbol not found"}

      {:ok, decoded_body} ->
        {:ok, decoded_body}

      {:error, _} ->
        {:error, "Invalid JSON response"}
    end
  end
end
