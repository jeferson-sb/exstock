defmodule Cache do
  @table_name :"model.dets"

  def open(opts \\ []) do
    :dets.open_file(opts[:table_name] || @table_name, opts)
  end

  def get(table_name \\ @table_name, key) do
    case :dets.lookup(table_name, key) do
      [{^key, value}] -> {:ok, value}
      [] -> {:ok, nil}
    end
  end

  def put(table_name \\ @table_name, key, value) do
    :dets.insert(table_name, {key, value})
  end
end
