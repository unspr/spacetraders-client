module Request(MailBox, sendHttp) where

import Network.HTTP.Simple
import Data.Aeson

type MailBox a = String -> Maybe Header-> Maybe Value -> IO a

sendHttp :: FromJSON a => MailBox a
sendHttp url mHeader mReqBody = do
    rawReq <- parseRequest url
    let reqWithHeader = maybe rawReq (\(headerName, v) -> setRequestHeader headerName [v] rawReq) mHeader
        reqWithBody = maybe reqWithHeader (`setRequestBodyJSON` reqWithHeader) mReqBody
    response <- httpJSON reqWithBody
    return $ getResponseBody response