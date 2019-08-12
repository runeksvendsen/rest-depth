module Main where

import MyPrelude
import qualified Options
import qualified Api.Handler as Handler
import qualified Api
import qualified Servant.Server as SS
import Servant.API
import qualified Network.HTTP.Client.TLS              as HTTPS
import qualified Network.Wai.Handler.Warp             as Warp
import qualified Network.HTTP.Client                  as HTTP
import qualified Network.Wai.Middleware.RequestLogger as RL


server :: HTTP.Manager -> Word -> SS.Server Api.Api
server man maxRetries = Handler.listVenues
   :<|> mkHandler Handler.listMarkets
   :<|> mkHandler Handler.slipSell
   :<|> mkHandler Handler.slipBuy
  where
   mkHandler handler = handler man maxRetries

app :: HTTP.Manager -> Word -> SS.Application
app man maxRetries = SS.serve (Proxy :: Proxy Api.Api) (server man maxRetries)

main :: IO ()
main = Options.withOptions $ \options -> do
   man <- HTTPS.newTlsManager
   let maxRetries = Options.numMaxRetries options
   Warp.run (fromIntegral $ Options.listenPort options) (RL.logStdoutDev $ app man maxRetries)
