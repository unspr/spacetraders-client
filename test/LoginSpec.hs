module LoginSpec (spec) where

import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)

import Login (tokenMVar, tryTakeMVar, loginImp, Tmp(Tmp))
import Data.Maybe (fromJust)
import Data.Aeson

spec :: Spec
spec = do
  describe "login" $ do
    it "log in and save auth token" $ do
      loginImp (return "test-user") (\url body -> do
        url `shouldBe` "POST https://api.spacetraders.io/v2/register"
        body `shouldBe` object ["symbol" .= ("test-user" :: String), "faction" .= ("COSMIC" :: String)]
        return $ Tmp "auth_token")
      token <- tryTakeMVar tokenMVar
      fromJust token `shouldBe` "auth_token"
  describe "Prelude.head" $ do
    it "returns the first element of a list" $ do
      head [23 ..] `shouldBe` (23 :: Int)

    it "returns the first element of an *arbitrary* list" $
      property $ \x xs -> head (x:xs) == (x :: Int)

    it "throws an exception if used with an empty list" $ do
      evaluate (head []) `shouldThrow` anyException