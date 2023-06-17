module AgentSpec (spec) where

import Test.Hspec
import Agent(getAgent, Agent(..))

spec :: Spec
spec = do
  describe "agent" $ do
    it "getAgent" $ do
        agent <- getAgent (\url mHeader mBody -> do
            url `shouldBe` "GET https://api.spacetraders.io/v2/my/agent"
            mHeader `shouldBe` Just ("Authorization", "Bearer test-token")
            mBody `shouldBe` Nothing
            return $ Agent
                { accountId = "12345"
                , symbol = "AGENT1"
                , headquarters = "City A"
                , credits = 1000
                , startingFaction = "Faction X"
                })
            (Just "test-token")
        accountId agent `shouldBe` "12345"