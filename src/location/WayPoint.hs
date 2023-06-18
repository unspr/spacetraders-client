module WayPoint(lsAgent, getAgent, Agent(..)) where

import Data.Aeson
import Data.Maybe
import Data.ByteString.UTF8 (fromString)
import Context(tokenMVar, tryReadMVar)
import Request
import Orbital

data WayPoint = WayPoint {
    systemSymbol :: String,
    symbol :: String,
    type :: String,
    x :: Int,
    y :: Int,
    orbitals :: [Orbital],
    traits :: [Trait]
} deriving(Show)

data Trait = Trait {
    symbol :: String,
    name :: String,
    description :: String,
} deriving(Show)


instance FromJSON WayPoint where
    parseJSON (Object v) = let dt = v .: "data" in WayPoint
        <$> (dt >>= (.: "systemSymbol"))
        <*> (dt >>= (.: "symbol"))
        <*> (dt >>= (.: "type"))
        <*> (dt >>= (.: "x"))
        <*> (dt >>= (.: "y"))
        <*> (dt >>= (.: "orbitals"))
        <*> (dt >>= (.: "traits"))
    parseJSON j = error $ show $ encode j


instance FromJSON Trait where
    parseJSON (Object v) = Trait
        <$> (v .: "symbol")
        <*> (v .: "name")
        <*> (v .: "description")
    parseJSON j = error $ show $ encode j


lsWayPoint :: IO ()
lsWayPoint = do
    mToken <- tryReadMVar tokenMVar
    wayPoint <- getWayPoint Request.sendHttp mToken
    print wayPoint

getWayPoint :: MailBox WayPoint -> Maybe String -> IO Agent
getAgent postMan mToken = do
    postMan "GET https://api.spacetraders.io/v2/systems/" ++ "/my/agent"
        (Just ("Authorization", fromString ("Bearer " ++ fromJust mToken)))
        Nothing