module Main where

import Parse
import TestData

main :: IO ()
main = print (parseLine "100,100,blah")
