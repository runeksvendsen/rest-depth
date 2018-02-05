module Main where

import MyPrelude
import qualified Api.Docs
import qualified Api.Handler as Handler
import qualified Api
import qualified Servant.Server as SS
import Servant.API
import qualified Network.HTTP.Client.TLS     as HTTPS
import qualified Network.Wai.Handler.Warp    as Warp
import qualified Network.HTTP.Client         as HTTP


server :: HTTP.Manager -> SS.Server Api.Api
server man = Handler.listVenues
   :<|> Handler.listMarkets man
   :<|> Handler.slipBuy man
   :<|> Handler.slipSell man

app :: HTTP.Manager -> SS.Application
app man = SS.serve (Proxy :: Proxy Api.Api) (server man)

main :: IO ()
main = do
   man <- HTTPS.newTlsManager
   Warp.run 8080 (app man)
