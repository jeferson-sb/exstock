defmodule Exstock.Query do
  @apiurl Application.get_env(:exstock, :finance_apiurl)
  @apikey Application.get_env(:exstock, :finance_apikey)

  def get_quote(symbol) do
    url_for(symbol)
    |> HTTPoison.get([{"Accept", "application/json"}, {"X-API-KEY", @apikey}])
    |> parse_response
  end

  defp url_for(symbol, params \\ [region: "US", lang: "en"]) do
    [region: region, lang: lang] = params

    "#{@apiurl}/v6/finance/quote?region=#{encoded_param(region)}&lang=#{encoded_param(lang)}&symbols=#{encoded_param(symbol)}"
  end

  defp encoded_param(param) when is_binary(param) do
    URI.encode(param)
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode!() |> process_quote
  end

  defp process_quote(json) do
    try do
      {:ok, json["quoteResponse"]["result"]}
    rescue
      _ -> :error
    end
  end
end
