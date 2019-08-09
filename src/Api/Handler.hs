module Api.Handler where

import RPrelude
import Api.Util
import CryptoVenues.Venues
import CryptoVenues.Fetch
import qualified CryptoVenues.Types.AppM    as AppM
import Markets.Parse
import OrderBook
import OrderBook.Output
import qualified Network.HTTP.Client   as HTTP
import qualified Servant.Server        as SS
import Control.Monad.Error.Class       (throwError)


maxRetries = 5

listVenues :: SS.Handler [AnyVenue]
listVenues = return allVenues

listMarkets
   :: HTTP.Manager
   -> Text
   -> SS.Handler [AnyMarket]
listMarkets man venueName =
   withVenue venueName $ \venue -> do
      let marketListIO = AppM.runAppM man maxRetries $ marketListAny venue
      throwErr =<< liftIO marketListIO

slipSell :: HTTP.Manager
         -> Text
         -> Text
         -> Double
         -> SS.Handler SlippageInfo
slipSell man venueName market slip =
   withMarket venueName market $ \(AnyMarket market) -> do
      let bookFetchIO = AppM.runAppM man maxRetries $ fetchMarketBook market
      AnyBook ob <- throwErr =<< liftIO bookFetchIO
      return $ fromMatchRes (slippageSell ob (realToFrac slip))

slipBuy :: HTTP.Manager
        -> Text
        -> Text
        -> Double
        -> SS.Handler SlippageInfo
slipBuy man venueName market slip =
   withMarket venueName market $ \(AnyMarket market) -> do
      let bookFetchIO = AppM.runAppM man maxRetries $ fetchMarketBook market
      AnyBook ob <- throwErr =<< liftIO bookFetchIO
      return $ fromMatchRes (slippageBuy ob (realToFrac slip))


-- Helpers
withVenue :: Text -> (AnyVenue -> SS.Handler r) -> SS.Handler r
withVenue venueName f =
   case venueLookup venueName of
      Nothing    -> throwError SS.err404
      Just venue -> f venue

withMarket :: Text -> Text -> (AnyMarket -> SS.Handler r) -> SS.Handler r
withMarket venueName marketName f =
   withVenue venueName $ \venue ->
      case fromString venue marketName of
         Just anyMarket -> f anyMarket
         Nothing        -> throwError
            SS.err400 { SS.errReasonPhrase = "Invalid market: " <> toS marketName
                      , SS.errBody = "Failed to parse market from string: " <> toS marketName
                      }


