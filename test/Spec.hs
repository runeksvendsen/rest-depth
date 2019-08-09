--module Spec where

import RPrelude

import qualified Spec.MarketString
import Markets.Parse                      (fromString, toString)

import Test.Tasty
import Test.Tasty.SmallCheck  as SC
import Test.Hspec             as HS
import Test.Hspec.Runner
import qualified Test.SmallCheck.Series as SS
import Orphans.Market
import qualified Network.HTTP.Client.TLS as HTTPS


scDepth = 4

main = do
   let runHspec = hspecWith defaultConfig { configSmallCheckDepth = scDepth }
   runHspec $ Spec.MarketString.spec


properties :: TestTree
properties = localOption (SC.SmallCheckDepth scDepth) $
   testGroup "Properties" [scProps]

scProps = testGroup "(checked by SmallCheck)"
  [ SC.testProperty "AnyMarket can be created from any String" $
      \(SS.NonEmpty base) (SS.NonEmpty quote) (HyphenStr apiSym) ->
         fromString testVenue (toS $ base ++ "-" ++ quote ++ "-" ++ apiSym)
               `shouldSatisfy` isJust
  , SC.testProperty "AnyMarket can be converted to/from any String" $
      \anyMarket ->
         fromString testVenue (toS $ toString anyMarket) `shouldBe` Just anyMarket
  ]

