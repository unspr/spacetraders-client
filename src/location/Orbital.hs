module Orbital(Orbital(..)) where

data Orbital =  Orbital {
    symbol :: String,
} deriving(Show)

instance FromJSON Orbital where
    parseJSON (Object v) = Orbital
        <$> (v .: "symbol")
    parseJSON j = error $ show $ encode j