module Api.Util where

import RPrelude
import qualified CryptoVenues.Types.Error as Error
import qualified Servant.Server        as SS


-- Util
throwErr :: Either Error.Error a -> SS.Handler a
throwErr = either (throwError . toServerError . Error.eFetchErr) return

-- | Convert crypto-venues 'Error.Error' to 'Servant.Server' throwable error
toServerError :: Error.FetchErr -> SS.ServerError
toServerError (Error.TooManyRequests _) =
   SS.ServerError
      { errHTTPCode = 429
      , errReasonPhrase = "Too many requests"
      , errBody = ""
      , errHeaders = []
      }
toServerError err@(Error.ConnectionErr _) = simple500Error (show err)
toServerError err@(Error.EndpointErr _ _) = simple500Error (show err)
toServerError err@(Error.InternalErr _) = simple500Error (show err)

simple500Error :: String -> SS.ServerError
simple500Error err =
   SS.err500 { SS.errBody = toS err, SS.errReasonPhrase = err }
