module Api
( Api
, ListVenues
, ListMarkets
, SlippageBuy
, SlippageSell
, AnyVenue(..)
, AnyMarket(..)
, Market(..)
, SlippageInfo(..)
) where

import RPrelude
import Markets.Types
import Venue.Types
import OrderBook.Output
import Fetch.MarketBook
import Servant.API


type Api = ListVenues :<|> ListMarkets :<|> SlippageSell :<|> SlippageBuy

type ListVenues
   = "list_venues"
   :> Get '[JSON] [AnyVenue]

type ListMarkets
   = Capture "venue" Text
   :> "list_markets"
   :> Get '[JSON] [AnyMarket]

type SlippageSell
   = Capture "venue" Text
   :> "slippage_sell"
   :> Capture "market" Text
   :> Capture "slippage" Double
   :> Get '[JSON] SlippageInfo

type SlippageBuy
   = Capture "venue" Text
   :> "slippage_buy"
   :> Capture "market" Text
   :> Capture "slippage" Double
   :> Get '[JSON] SlippageInfo
