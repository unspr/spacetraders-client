module Login
    ( tokenMVar, login, tryTakeMVar, loginImp, Tmp(Tmp)
    ) where

import Data.Aeson
import Control.Concurrent.MVar
import System.IO.Unsafe (unsafePerformIO)
import Request

-- https://hackage.haskell.org/package/base-4.18.0.0/docs/System-IO-Unsafe.html#v:unsafePerformIO
{-# NOINLINE tokenMVar #-}
tokenMVar :: MVar String
tokenMVar = unsafePerformIO newEmptyMVar

-- refreshToken :: IO String
-- refreshToken = do
--   tk <- tryTakeMVar token
--   case tk of
--     Just t -> return t
--     Nothing -> do
--       t <- login
--       putMVar token t
--       return t

newtype Tmp = Tmp String
getStr :: Tmp -> String
getStr (Tmp a) = a 

instance FromJSON Tmp where
    parseJSON (Object v) = Tmp <$> (v .: "data" >>= (.: "token"))
    parseJSON j = error $ show $ encode j


login :: IO String
login = loginImp getLine Request.sendHttp

loginImp :: IO String ->  MailBox Tmp -> IO String
loginImp getUserName postMan = do
    putStr "Please input the user name: "
    userName <- getUserName
    resBody <- postMan "POST https://api.spacetraders.io/v2/register" $ object ["symbol" .= (userName :: String), "faction" .= ("COSMIC" :: String)]
    putMVar tokenMVar $ getStr resBody
    return "login success"