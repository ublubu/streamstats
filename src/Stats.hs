module Stats where

-- For all columns:

countFolder :: Num n => n -> a -> n
countFolder accum _ = accum + 1

countFolder0 :: Num n => n
countFolder0 = 0

nullCountFolder :: Num n => (a -> Bool) -> n -> a -> n
nullCountFolder isNull accum a = if (isNull a) then countFolder accum a else accum

-- For number columns:

minFolder :: Ord n => Maybe n -> n -> Maybe n
minFolder = extremeFolder (<)

maxFolder :: Ord n => Maybe n -> n -> Maybe n
maxFolder = extremeFolder (>)

extremeFolder :: (n -> n -> Bool) -> Maybe n -> n -> Maybe n
extremeFolder ord accum x = case accum of
  Just ext -> if (x `ord` ext) then Just x
              else accum
  Nothing -> Just x

meanFolder :: Fractional n => (n, n) -> n -> (n, n)
meanFolder (count, mean) x = (count', (mean * (count / count')) + (x / count'))
  where count' = count + 1

meanFolder0 :: Fractional n => (n, n)
meanFolder0 = (0, 0)

extractMean :: (a, b) -> b
extractMean = snd

-- For text columns:

countShortestFolder :: Num n => (String, Int, n) -> String -> (String, Int, n)
countShortestFolder = lengthExtremeCounter (<)

countLongestFolder :: Num n => (String, Int, n) -> String -> (String, Int, n)
countLongestFolder = lengthExtremeCounter (>)

-- use 'ord' to find the most extreme string
-- break ties alphabetically (A is most extreme)
lengthExtremeCounter :: Num n => (Int -> Int -> Bool) -> (String, Int, n) -> String -> (String, Int, n)
lengthExtremeCounter ord accum@(extremest, len, count) str =
  if str == extremest then (extremest, len, count + 1)
  else if len' `ord` len || (len' == len && str < extremest) then (str, len', 1)
       else accum
  where len' = length str

meanLengthFolder :: Fractional n => (n, n) -> String -> (n, n)
meanLengthFolder accum s = meanFolder accum (fromIntegral $ length s)
