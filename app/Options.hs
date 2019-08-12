module Options
( withOptions
, Options(..)
)
where

import           Prelude
import           Options.Applicative
import qualified Control.Logging                            as Log


data Options = Options
  { listenPort      :: Word
  , numMaxRetries   :: Word
  , logLevel        :: Log.LogLevel
  } deriving (Eq, Show)

withOptions :: (Options -> IO ()) -> IO ()
withOptions f = do
    parsedOptions <- execParser opts
    setLogLevel parsedOptions
    Log.withStderrLogging (f parsedOptions)
  where
    setLogLevel = Log.setLogLevel . logLevel

opts :: ParserInfo Options
opts = info options $
     fullDesc
  <> progDesc "Analyze cryptocurrency order book depth"
  <> header "Cryptocurrency order book depth"

options :: Parser Options
options = Options
    <$> listenPortOpt
    <*> numMaxRetriesOpt
    <*> verboseOpt

listenPortOpt :: Parser Word
listenPortOpt = option auto $
     long "port"
  <> short 'p'
  <> value 8080
  <> metavar "LISTEN_PORT"
  <> help "Port to listen on for incoming connections"

numMaxRetriesOpt :: Parser Word
numMaxRetriesOpt = option auto $
     long "max-retries"
  <> short 'r'
  <> value 5
  <> metavar "MAX_RETRIES"
  <> help "Maximum number of request retries before failing"

verboseOpt :: Parser Log.LogLevel
verboseOpt = flag Log.LevelError Log.LevelDebug $
     long "verbose"
  <> short 'v'
  <> help "Output debug logs"
