module DataTypes where

import Data.Vector (Vector)
import Stats

data ColumnType = StringCol | DoubleCol
type StringOrDouble = Either String Double
type Row = Vector (Maybe StringOrDouble)
type Header = Vector ColumnType
