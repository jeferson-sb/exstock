defmodule Tracker.Query.Test do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Tracker.Query

  setup_all do
    HTTPoison.start()
    :ok
  end

  test "get_latest_symbol/1" do
    use_cassette "get_latest_symbol" do
      {:ok, response} = Query.get_latest_symbol("AAPL")
      assert response["symbol"] == "AAPL"
      assert response["exchange"] == "NASDAQ"
      assert response["currency"] == "USD"
    end
  end

  test "get_currency_conversion/3" do
    use_cassette "get_currency_conversion" do
      {:ok, response} = Query.get_currency_conversion("USD", "BRL", 1)
      assert response["symbol"] == "USD/BRL"
    end
  end

  test "get_exchange_rate/2" do
    use_cassette "get_exchange_rate" do
      {:ok, response} = Query.get_exchange_rate("USD", "JPY")
      assert response["symbol"] == "USD/JPY"
    end
  end

  test "eod_price/1" do
    use_cassette "eod_price" do
      {:ok, response} = Query.eod_price("AAPL")
      assert response["symbol"] == "AAPL"
      assert response["exchange"] == "NASDAQ"
      assert response["currency"] == "USD"
    end
  end

  test "get_paid_dividends/1" do
    use_cassette "get_paid_dividends" do
      {:ok, response} = Query.get_paid_dividends("AAPL")
      assert length(response["data"]) > 1
    end
  end

  test "get_company_stats/1" do
    use_cassette "get_company_stats" do
      {:ok, response} = Query.get_company_stats("AAPL")
      assert response["Name"] == "Apple Inc"
      assert response["Country"] == "USA"
      assert response["Sector"] == "TECHNOLOGY"
      assert response["EBITDA"]
    end
  end

  test "Cryptocurrency" do
    use_cassette "cryptocurrency" do
      {:ok, response} = Query.get_latest_symbol("eth/usd")
      assert response["name"] == "Ethereum US Dollar"
      assert response["exchange"] == "Huobi"
    end
  end

  test "Not found" do
    use_cassette "not_found" do
      {:error, message} = Query.get_latest_symbol("NOT_FOUND")
      assert message == "Symbol not found"
    end
  end
end
