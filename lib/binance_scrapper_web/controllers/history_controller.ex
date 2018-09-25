# lib/controllers/order_controller.ex

defmodule BinanceScrapperWeb.HistoryController do
  	use BinanceScrapperWeb, :controller
    import Ecto.Query, warn: false


  	def check(conn, %{"min" => minutes,"ticker" => ticker}) do
  		with_changes = BinanceScrapper.check(%{"min" => minutes,"ticker" => ticker})
      json(conn, with_changes)
    end
    
    def checkVolume(conn, %{"min" => minutes,"ticker" => ticker}) do
      with_changes = BinanceScrapper.checkVolume(%{"min" => minutes,"ticker" => ticker})
      json(conn, with_changes)
    end       

end