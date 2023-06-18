module Context(tryReadMVar, putMVar, tokenMVar) where

import Control.Concurrent.MVar
import System.IO.Unsafe (unsafePerformIO)

-- https://hackage.haskell.org/package/base-4.18.0.0/docs/System-IO-Unsafe.html#v:unsafePerformIO
{-# NOINLINE tokenMVar #-}
tokenMVar :: MVar String
tokenMVar = unsafePerformIO newEmptyMVar

{-# NOINLINE systemSymbol #-}
systemSymbol :: MVar String
systemSymbol = unsafePerformIO newEmptyMVar

{-# NOINLINE symbol #-}
symbol :: MVar String
symbol = unsafePerformIO newEmptyMVar