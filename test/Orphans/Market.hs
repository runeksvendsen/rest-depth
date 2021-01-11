module Orphans.Market where

import RPrelude
import CryptoVenues.Types.Market
import CryptoVenues.Fetch
import qualified CryptoVenues.Types.MarketSymbol as CryptoVenues
import qualified Test.SmallCheck.Series as SS
import Data.Aeson


type TestVenueName = "__TEST_VENUE"

testVenue :: AnyVenue
testVenue = AnyVenue (Proxy :: Proxy TestVenueName)

instance MarketBook TestVenueName where
   marketBook = undefined
   rateLimit = undefined

instance EnumMarkets TestVenueName where
   allMarkets = undefined

instance FromJSON (MarketList TestVenueName) where
   parseJSON = undefined

newtype HyphenChar = HyphenChar {hcGet :: Char}
newtype HyphenStr = HyphenStr String

instance Show HyphenStr where
   show (HyphenStr str) = show str

instance Monad m => SS.Serial m HyphenChar where
   series = HyphenChar <$> SS.generate (\d -> take (d+1) ['a','-','c','d'])

instance Monad m => SS.Serial m HyphenStr where
   series = do
      SS.NonEmpty str :: SS.NonEmpty HyphenChar <- SS.series
      return $ HyphenStr (map hcGet str)

instance Monad m => SS.Serial m AnyMarket where
      series = do
         SS.NonEmpty base  :: SS.NonEmpty Char <- SS.series
         SS.NonEmpty quote :: SS.NonEmpty Char <- SS.series
         HyphenStr sym <- SS.series
         let market = Market
               (toS base)
               (toS quote)
               (CryptoVenues.toMarketSymbol $ toS sym) :: Market TestVenueName
         return (AnyMarket market)
