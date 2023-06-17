module Agent(lsAgent, getAgent, Agent(..)) where

import Data.Aeson
import Data.Maybe
import Data.ByteString.UTF8 (fromString)
import Context(tokenMVar, tryReadMVar)
import Request

data Agent = Agent {
    accountId :: String,
    symbol :: String,
    headquarters :: String,
    credits :: Int,
    startingFaction :: String
} deriving(Show)

instance FromJSON Agent where
    parseJSON (Object v) = let dt = v .: "data" in Agent
        <$> (dt >>= (.: "accountId"))
        <*> (dt >>= (.: "symbol"))
        <*> (dt >>= (.: "headquarters"))
        <*> (dt >>= (.: "credits"))
        <*> (dt >>= (.: "startingFaction"))
    parseJSON j = error $ show $ encode j

lsAgent :: IO ()
lsAgent = do
    mToken <- tryReadMVar tokenMVar
    agent <- getAgent Request.sendHttp mToken
    print agent

getAgent :: MailBox Agent -> Maybe String -> IO Agent
getAgent postMan mToken = do
    postMan "GET https://api.spacetraders.io/v2/my/agent"
        (Just ("Authorization", fromString ("Bearer " ++ fromJust mToken)))
        Nothing