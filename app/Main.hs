module Main where

import MyPrelude
import qualified Api.Handler as Handler
import qualified Api
import qualified Servant.Server as SS
import Servant.API
import qualified Network.HTTP.Client.TLS              as HTTPS
import qualified Network.Wai.Handler.Warp             as Warp
import qualified Network.HTTP.Client                  as HTTP
import qualified Network.Wai.Middleware.RequestLogger as RL
import qualified Control.Logging                      as Log


server :: HTTP.Manager -> SS.Server Api.Api
server man = Handler.listVenues
   :<|> Handler.listMarkets man
   :<|> Handler.slipSell man
   :<|> Handler.slipBuy man

app :: HTTP.Manager -> SS.Application
app man = SS.serve (Proxy :: Proxy Api.Api) (server man)

main :: IO ()
main = do
   man <- HTTPS.newTlsManager
   Log.setLogLevel Log.LevelError -- TODO: CLI argument
   Log.withStderrLogging $
      Warp.run 8080 (RL.logStdoutDev $ app man)
