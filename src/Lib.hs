module Lib where

import Login (login )
import Agent

begin :: IO String
begin = login
