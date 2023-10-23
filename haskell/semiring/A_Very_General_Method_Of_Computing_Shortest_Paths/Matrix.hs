module A_Very_General_Method_Of_Computing_Shortest_Paths.Matrix where

import Data.Array
import Data.Maybe
import Data.List
import Control.Applicative
import Control.Monad

data Edge i = i :-> i deriving (Eq, Ord, Bounded, Ix)

instance Show a => Show (Edge a) where
  showsPrec _ (i :-> j) = showParen True (shows i . shows j)

newtype Matrix i e = Matrix (Array (Edge i) e)

matrix :: (Ix i, Bounded i) => (Edge i -> e) -> Matrix i e
matrix f = Matrix . listArray (minBound, maxBound) . map f $ entireRange

entireRange :: (Ix i, Bounded i) => [i]
entireRange = range (minBound, maxBound)

instance (Ix i) => Functor (Matrix i) where
  fmap f (Matrix m) = Matrix (fmap f m)

instance (Ix i, Bounded i) => Applicative (Matrix i) where
  pure x = matrix (const x)
  Matrix f <*> Matrix x = matrix (\(i :-> j) -> (f!(i :-> j)) (x!(i :-> j)))

-- some matrix methods

transpose :: (Ix i, Bounded i) => Matrix i a -> Matrix i a
transpose (Matrix m) = matrix (\(i :-> j) -> m!(j :-> i))

showMatrix :: (Ix i, Bounded i, Show a) => Matrix i a -> String
showMatrix (Matrix m) =
  unlines [concat [pad (m'!(i :-> j)) j | j <- entireRange]
          | i <- entireRange]
 where
  m' = fmap show m
  lenm = fmap length m'
  len j = maximum [lenm!(i :-> j) | i <- entireRange]
  pad s j = s ++ replicate ((len j) - (length s) +1) ' '

printMatrix :: (Ix i, Bounded i, Show a) => Matrix i a -> IO ()
printMatrix = putStrLn . showMatrix

