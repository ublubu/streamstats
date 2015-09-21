module Parse where

import Data.Vector (Vector, fromList)
import Text.Read (readMaybe)
import DataTypes

split :: String -> Char -> [String]
split cs delim = fmap reverse . reverse $ (current':all')
  where f (all, current) c = if c == delim then (current:all, [])
                             else (all, c:current)
        (all', current') = foldl f ([], []) cs

maybeToEither :: a -> Maybe b -> Either a b
maybeToEither a mb = case mb of Just b -> Right b
                                Nothing -> Left a

parseOne :: String -> StringOrDouble
parseOne elem = maybeToEither elem (readMaybe elem)

parseLine :: String -> Vector StringOrDouble
parseLine line = fromList . fmap parseOne $ line `split` ','
