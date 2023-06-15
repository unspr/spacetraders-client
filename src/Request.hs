module Request(MailBox, sendHttp) where

import Network.HTTP.Simple
import Data.Aeson

type MailBox a = String -> Value -> IO a

sendHttp :: FromJSON a => MailBox a
sendHttp url reqBody = do
    rawReq <- parseRequest url
    let request = setRequestBodyJSON reqBody rawReq
    response <- httpJSON request
    return $ getResponseBody response