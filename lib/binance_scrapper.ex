defmodule BinanceScrapper do
  @moduledoc """
  BinanceScrapper keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  import Ecto.Query, warn: false

  def check(%{"min" => minutes,"ticker" => ticker}) do
  		
    tickers = String.split(ticker, ",")

    {minutes, _} = Integer.parse(minutes)
    now = DateTime.utc_now |> DateTime.to_unix()
    
    timestamp = DateTime.from_unix!(now - minutes * 60 )  |> DateTime.to_naive

    history = BinanceScrapper.History
    |> where([u], u.inserted_at >= ^timestamp)
    |> limit(1)
    |>  BinanceScrapper.Repo.all
    
    present = BinanceScrapper.History 
    |> order_by(desc: :id)
    |> limit(1)
    |>  BinanceScrapper.Repo.all
    
    prices_before = Poison.decode!(Enum.at(history, 0).prices)
    prices_after = Poison.decode!(Enum.at(present, 0).prices)
    iprices_after = Enum.with_index(prices_after)

    with_changes = 
    Enum.map(iprices_after, fn{x, i} -> 
      {bp, _} = Float.parse(Enum.at(prices_before,i)["price"])
      {ap, _} = Float.parse(x["price"])

      bv = Enum.at(prices_before,i)["volume"]
      av = x["volume"]        

      %{
        "symbol"=> x["symbol"],
        "price"=>ap,
        "before_price"=> bp,
        "change"=> (ap - bp) / bp  * 100,
        "_volume"=>av,
        "_before_volume"=> bv,
        "_change_v"=> (av - bv) / bv  * 100
      }
    end)
    |> Enum.filter(fn x ->  String.contains? x["symbol"], tickers end)
    |> Enum.sort_by(fn(x) -> -x["change"] end)

    with_changes
  end
  def checkVolume( %{"min" => minutes,"ticker" => ticker}) do
  		
    tickers = String.split(ticker, ",")

    {minutes, _} = Integer.parse(minutes)
    now = DateTime.utc_now |> DateTime.to_unix()
    
    timestamp = DateTime.from_unix!(now - minutes * 60 )  |> DateTime.to_naive

    history = BinanceScrapper.History
    |> where([u], u.inserted_at >= ^timestamp)
    |> limit(1)
    |>  BinanceScrapper.Repo.all
    
    present = BinanceScrapper.History 
    |> order_by(desc: :id)
    |> limit(1)
    |>  BinanceScrapper.Repo.all
    
    prices_before = Poison.decode!(Enum.at(history, 0).prices)
    prices_after = Poison.decode!(Enum.at(present, 0).prices)
    iprices_after = Enum.with_index(prices_after)

    with_changes = 
    Enum.map(iprices_after, fn{x, i} -> 
      bv = Enum.at(prices_before,i)["volume"]
      av = x["volume"]
      {bp, _} = Float.parse(Enum.at(prices_before,i)["price"])
      {ap, _} = Float.parse(x["price"])        

      %{
        "symbol"=> x["symbol"],
        "rvolume"=>av,
        "before_volume"=> bv,
        "change_v"=> (av - bv) / bv  * 100,
        "_price"=>ap,
        "_before_price"=> bp,
        "_change"=> (ap - bp) / bp  * 100
      }
    end)
    |> Enum.filter(fn x ->  String.contains? x["symbol"], tickers end)
    |> Enum.sort_by(fn(x) -> -x["change_v"] end)

    with_changes
  end 
end
