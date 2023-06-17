module Login
    ( tokenMVar, login, loginImp, AutoToken(AutoToken)
    ) where

import Data.Aeson
import Context(tokenMVar, putMVar)
import Request

login :: IO String
login = loginImp getLine Request.sendHttp

newtype AutoToken = AutoToken String
instance FromJSON AutoToken where
    parseJSON (Object v) = AutoToken <$> (v .: "data" >>= (.: "token"))
    parseJSON j = error $ show $ encode j

loginImp :: IO String ->  MailBox AutoToken -> IO String
loginImp getUserName postMan = do
    putStr "Please input the user name: "
    userName <- getUserName
    (AutoToken token) <- postMan "POST https://api.spacetraders.io/v2/register"
        Nothing (Just (object ["symbol" .= (userName :: String), "faction" .= ("COSMIC" :: String)]))
    putMVar tokenMVar token
    return "login success"