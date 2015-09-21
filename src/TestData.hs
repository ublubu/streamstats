module TestData where

import System.Random
import DataTypes

randomStrings :: RandomGen g => (Int, Int) -> g -> [String]
randomStrings range gen = str:(randomStrings range gen')
  where (str, gen') = randomString range gen

randomString :: RandomGen g => (Int, Int) -> g -> (String, g)
randomString range gen = randomString_ len gen'
  where (len, gen') = randomR range gen

randomString_ :: RandomGen g => Int -> g -> (String, g)
randomString_ 0 g = ([], g)
randomString_ len g = (c:cs, g'')
  where (c, g') = randomR ('a', 'z') g
        (cs, g'') = randomString_ (len - 1) g'

randomStringIO :: Int -> IO String
randomStringIO len = do
  gen <- getStdGen
  let (str, _) = randomString_ len gen in return str

randomDoubles :: RandomGen g => (Double, Double) -> g -> [Double]
randomDoubles range gen = x:(randomDoubles range gen')
  where (x, gen') = randomDouble range gen

randomDouble :: RandomGen g => (Double, Double) -> g -> (Double, g)
randomDouble range gen = randomR range gen

randomDoublesIO = toRandomRsIO randomDoubles
randomStringsIO = toRandomRsIO randomStrings

toRandomRsIO :: ((a, a) -> StdGen -> [b]) -> (a, a) -> IO [b]
toRandomRsIO f range = do
  gen <- getStdGen
  return $ f range gen

