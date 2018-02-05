module Api.Util where

import RPrelude
import Venues
import OrderBook
import Markets
import Fetch
import qualified Network.HTTP.Client   as HTTP
import qualified Servant.Common.Req    as Req
import qualified Servant.Server        as SS
import qualified Network.HTTP.Types.Status as HTTP


-- Util
throwErr :: Either Req.ServantError a -> SS.Handler a
throwErr = either (throwError . toServantErr) return

-- | Convert 'Servant.Client' response status error to 'Servant.Server' throwable error
toServantErr :: Req.ServantError -> SS.ServantErr
toServantErr Req.FailureResponse{..} =
   SS.ServantErr
      { errHTTPCode = HTTP.statusCode responseStatus
      , errReasonPhrase = "API failure response"
      , errBody = responseBody
      , errHeaders = []
      }
toServantErr Req.DecodeFailure{..} = let err = "Decode error: " ++ decodeError in
   SS.err500 { SS.errBody = toS err, SS.errReasonPhrase = err }
toServantErr ex = let err = show ex in
   SS.err500 { SS.errBody = toS err, SS.errReasonPhrase = err }

marketList'
   :: forall venue.
   ( KnownSymbol venue
   , DataSource (MarketList venue)
   )
   => HTTP.Manager
   -> Proxy venue
   -> IO (Either Req.ServantError (MarketList venue))
marketList' man _ = fetch man

marketList :: HTTP.Manager -> AnyVenue -> IO (Either Req.ServantError [AnyMarket])
marketList man (AnyVenue p) = do
   resE <- marketList' man p
   let getMarket (MarketList a) = a
   return $ map AnyMarket . getMarket <$> resE

