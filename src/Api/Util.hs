module Api.Util where

import RPrelude
import CryptoVenues.Venues
import OrderBook
import CryptoVenues.Fetch
import qualified CryptoVenues.Types.Error as Error
import qualified Network.HTTP.Client   as HTTP
import qualified Servant.Client        as Req
import qualified Servant.Server        as SS
import qualified Network.HTTP.Types.Status as HTTP


-- Util
throwErr :: Either Error.Error a -> SS.Handler a
throwErr = either (throwError . toServantErr . Error.eFetchErr) return

-- | Convert crypto-venues 'Error.Error' to 'Servant.Server' throwable error
toServantErr :: Error.FetchErr -> SS.ServantErr
toServantErr Error.TooManyRequests =
   SS.ServantErr
      { errHTTPCode = 429
      , errReasonPhrase = "Too many requests"
      , errBody = ""
      , errHeaders = []
      }
toServantErr err@(Error.ConnectionErr _) = simple500Error (show err)
toServantErr err@(Error.EndpointErr _) = simple500Error (show err)
toServantErr err@(Error.InternalErr _) = simple500Error (show err)

simple500Error :: String -> SS.ServantErr
simple500Error err =
   SS.err500 { SS.errBody = toS err, SS.errReasonPhrase = err }

