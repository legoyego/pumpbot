defmodule BinanceScrapper.ScrapIt do
  use GenServer

  alias BinanceScrapper.History

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    {:ok, prices} = Binance.get_all_prices

    p = []
    p = for x <- prices do
      {:ok, tick} = Binance.get_ticker(x.symbol)
      {v,_} = Float.parse(tick.volume)
      {lp,_} = Float.parse(tick.last_price)
      volume = v*lp
      
      %{
        price: x.price, 
        symbol: x.symbol,
        volume: volume
      }
    end
    BinanceScrapper.Repo.insert(History.changeset(%History{}, %{prices: Poison.encode!(p) } ))
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1 * 1 * 10 * 1000) # In 10 seconds
  end
end