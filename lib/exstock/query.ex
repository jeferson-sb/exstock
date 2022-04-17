defmodule Exstock.Query do
  @apiurl Application.get_env(:exstock, :finance_apiurl)
  @apikey Application.get_env(:exstock, :finance_apikey)

  def quote(symbol) do
    url_for(symbol)
    |> HTTPoison.get([{"Accept", "application/json"}, {"X-API-KEY", @apikey}])
    |> parse_response
    |> process_quote()
  end

  def recommendation_trend(symbol) do
    "#{@apiurl}/v11/finance/quoteSummary/#{symbol}?lang=en&region=US&modules=recommendationTrend"
    |> HTTPoison.get([{"Accept", "application/json"}, {"X-API-KEY", @apikey}])
    |> parse_response()
    |> process_quote()
  end

  def summary_price(symbol) do
    "#{@apiurl}/v11/finance/quoteSummary/#{symbol}?lang=en&region=US&modules=price"
    |> HTTPoison.get([{"Accept", "application/json"}, {"X-API-KEY", @apikey}])
    |> parse_response()
  end

  defp url_for(symbol, params \\ [region: "US", lang: "en"]) do
    [region: region, lang: lang] = params

    "#{@apiurl}/v6/finance/quote?region=#{encoded_param(region)}&lang=#{encoded_param(lang)}&symbols=#{encoded_param(symbol)}"
  end

  defp encoded_param(param) when is_binary(param) do
    URI.encode(param)
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode!()
  end

  defp parse_response({:error, response}) do
    {:error, response}
  end

  defp process_quote(%{"quoteResponse" => response}) do
    try do
      data = response["result"] |> List.first()
      {:ok, process_fields(data)}
    rescue
      exception -> {:error, exception}
    end
  end

  defp process_quote(%{"quoteSummary" => response}) do
    try do
      data = response["result"] |> List.first()
      {:ok, data}
    rescue
      exception -> {:error, exception}
    end
  end

  defp process_fields(data = %{"quoteType" => "EQUITY"}) do
    %{
      "regularMarketDayHigh" => high,
      "regularMarketDayLow" => low,
      "postMarketPrice" => closePrice,
      "regularMarketPrice" => price,
      "shortName" => name
    } = data

    %{high: high, low: low, closePrice: closePrice, price: price, name: name, type: "STOCK"}
  end

  defp process_fields(data = %{"quoteType" => "CRYPTOCURRENCY"}) do
    %{
      "regularMarketDayHigh" => high,
      "regularMarketDayLow" => low,
      "regularMarketPrice" => price,
      "shortName" => name
    } = data

    %{high: high, low: low, price: price, name: name, type: "CRYPTO"}
  end
end
