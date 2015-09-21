module Streaming where

import Control.Monad
import Data.Vector
import DataTypes
import Stats

type RowAccum = Vector ColumnAccum
rowAccum0 :: Header -> RowAccum
rowAccum0 header = fmap columnAccum header

-- 'bad' rows are just being thrown out as Nothing
rowFolder :: Header -> RowAccum -> Row -> Maybe RowAccum
rowFolder header rowAccum row = let len = length header in do
  guard (len == length rowAccum && len == length row)
  generateM len f
  where f i = columnFolder colType accum val
          where colType = header ! i
                accum = rowAccum ! i
                val = row ! i

data StringAccum = StringAccum { strShortestCount :: Int
                               , strLongestCount :: Int
                               , strMeanLength :: Double }
stringAccum0 :: StringAccum
stringAccum0 = StringAccum 0 0 meanFolder0

stringFolder :: StringAccum -> String -> StringAccum
stringFolder (StringAccum shortest longest mean) s =
  StringAccum { strShortestCount = countShortestFolder shortest s
              , strLongestCount = countLongestFolder longest s
              , strMeanLength = meanLengthFolder mean s }

data DoubleAccum = DoubleAccum { dblMax :: Double
                               , dblMin :: Double
                               , dblMean :: Double }
doubleAccum0 :: DoubleAccum
doubleAccum0 = DoubleAccum Nothing Nothing meanFolder0

doubleFolder :: DoubleAccum -> Double -> DoubleAccum
doubleFolder (DoubleAccum dmax dmin dmean) x =
  DoubleAccum { dblMax = maxFolder dmax x
              , dblMin = minFolder dmin x
              , dblMean = meanFolder dmean x }

data ColumnAccum = ColumnAccum { colCount :: Int
                               , colNullCount :: Int
                               , colStats :: Either StringAccum DoubleAccum }
columnAccum0 :: ColumnType -> ColumnAccum
columnAccum0 colType = ColumnAccum { colCount = 0
                                   , colNullCount = 0
                                   , colStats = byColumnType stringAccum0 doubleAccum0 }

eitherApply :: Either (a -> b) (c -> d) -> Either a c -> Maybe (Either b d)
eitherApply (Left f) (Left x) = Just (Left $ f x)
eitherApply (Right f) (Right x) = Just (Right $ f x)
eitherApply _ _ = Nothing

byColumnType :: ColumnType -> a -> b -> Either a b
byColumnType StringCol x _ = Left x
byColumnType DoubleCol _ x = Right x

columnFolder_ :: ColumnType -> ColumnAccum -> StringOrDouble -> Maybe ColumnAccum
columnFolder_ colType (ColumnAccum count nullCount stats) val =
  let folder = byColumnType stringFolder doubleFolder in do
    stats' <- eitherApply getStats val
    return $ ColumnAccum { colCount = countFolder count val
                         , colNullCount = nullCount
                         , colStats = stats' }
      where getStats = fromJust (folder stats) -- folder not matching accum is coding error

columnFolder :: ColumnType -> ColumnAccum -> Maybe StringOrDouble -> Maybe ColumnAccum
columnFolder colType accum (Just val) = columnFolder colType accum val
columnFolder colType accum Nothing =
  accum { colNullCount = countFolder (colNullCount accum) () }
