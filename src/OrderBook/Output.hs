module OrderBook.Output where

import RPrelude
import OrderBook.Types
import OrderBook.Matching
import qualified Money
import Data.Aeson
import qualified Data.Scientific as Sci


data SlippageInfo = SlippageInfo
   { base_qty           :: Double
   , quote_qty          :: Double
   , init_price         :: Maybe Double
   , avg_price          :: Maybe Double
   , slippage_percent   :: Maybe Double
   , orders_exhausted   :: Bool
   } deriving (Eq, Show, Generic)

instance ToJSON SlippageInfo

fromMatchRes
   :: MatchResult base quote
   -> SlippageInfo
fromMatchRes mr@MatchResult{..} = SlippageInfo
   { base_qty           = fromRational $ toRational resBaseQty
   , quote_qty          = fromRational $ toRational resQuoteQty
   , init_price         = fromRational . Money.fromExchangeRate . oPrice <$> lastMay resOrders
   , avg_price          = fromRational . Money.fromExchangeRate <$> executionPrice mr
   , slippage_percent   = fromRational <$> slippage mr
   , orders_exhausted   = resRes == InsufficientDepth
   }
