module Lib
    ( begin, tokenMVar, tryTakeMVar
    ) where

import Login (login, tokenMVar, tryTakeMVar)

begin :: IO String
begin = login
