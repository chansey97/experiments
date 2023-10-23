module A_Very_General_Method_Of_Computing_Shortest_Paths.Graph where

import Data.Array
import Data.Maybe
import Data.List
import Control.Applicative
import Control.Monad

import A_Very_General_Method_Of_Computing_Shortest_Paths.Matrix

-- We will represent directed graph by its adjacency matrix.
-- We build our own version of the Booleans called Connection

data Connection = Connected | Unconnected deriving Eq

instance Show Connection  where
  show Connected   = "*"
  show Unconnected = "0"

type Graph i = Matrix i Connection

graph :: (Ix i, Bounded i) => [Edge i] -> Graph i
graph edgeList = matrix build
 where
  build i | i `elem` edgeList = Connected
          | otherwise         = Unconnected

type LabeledGraph i = Matrix i (Maybe (Edge i))

labelGraph :: (Ix i, Bounded i) => Graph i -> LabeledGraph i
labelGraph m = f <$> m <*> matrix id
 where
  f Connected   l = Just l
  f Unconnected _ = Nothing

connect :: (Ix i) => Matrix i (Maybe a) -> Graph i
connect = fmap (maybe Unconnected (const Connected))
