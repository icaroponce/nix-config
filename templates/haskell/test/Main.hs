module Main (main) where

import Control.Monad (unless)
import Lib (greet)
import System.Exit (exitFailure)

main :: IO ()
main = unless (greet "x" == "Hello, x!") exitFailure
