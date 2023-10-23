module A_Very_General_Method_Of_Computing_Shortest_Paths.Matrix_test where

import Data.Array
import Data.Maybe
import Data.List hiding (transpose)
import Control.Applicative
import Control.Monad

import A_Very_General_Method_Of_Computing_Shortest_Paths.Matrix

matrix2x2 :: Num a => Matrix Bool a
matrix2x2 = matrix value
 where
  value (False :-> False) = 2
  value (False :-> True ) = 1
  value (True  :-> False) = 0
  value (True  :-> True ) = 2

--λ> printMatrix $ matrix2x2
--2 1
--0 2

data FinNum3 = FinNum3 Int
             deriving (Ix, Eq, Ord, Show)

instance Bounded FinNum3 where
  minBound = FinNum3 1
  maxBound = FinNum3 3

-- λ> printMatrix $ matrix id
-- (()())

-- λ> printMatrix $ ((matrix :: (Edge FinNum3 -> e) -> Matrix FinNum3 e) id)
-- (FinNum3 1 FinNum3 1) (FinNum3 1 FinNum3 2) (FinNum3 1 FinNum3 3)
-- (FinNum3 2 FinNum3 1) (FinNum3 2 FinNum3 2) (FinNum3 2 FinNum3 3)
-- (FinNum3 3 FinNum3 1) (FinNum3 3 FinNum3 2) (FinNum3 3 FinNum3 3)

-- λ> printMatrix $ (matrix id :: Matrix FinNum3 (Edge FinNum3))
-- (FinNum3 1 FinNum3 1) (FinNum3 1 FinNum3 2) (FinNum3 1 FinNum3 3)
-- (FinNum3 2 FinNum3 1) (FinNum3 2 FinNum3 2) (FinNum3 2 FinNum3 3)
-- (FinNum3 3 FinNum3 1) (FinNum3 3 FinNum3 2) (FinNum3 3 FinNum3 3)


--{{0,15,3},
--{28,7,2},
--{5,1,0}}
matrix3x3 :: Num a => Matrix FinNum3 a
matrix3x3 = matrix value
 where
  value (FinNum3 1 :-> FinNum3 1) = 0
  value (FinNum3 1 :-> FinNum3 2) = 15
  value (FinNum3 1 :-> FinNum3 3) = 3
  value (FinNum3 2 :-> FinNum3 1) = 28
  value (FinNum3 2 :-> FinNum3 2) = 7
  value (FinNum3 2 :-> FinNum3 3) = 2
  value (FinNum3 3 :-> FinNum3 1) = 5
  value (FinNum3 3 :-> FinNum3 2) = 1
  value (FinNum3 3 :-> FinNum3 3) = 0

--λ> printMatrix $ matrix3x3
--0  15 3
--28 7  2
--5  1  0

--{{0,1,0},
--{0,0,1},
--{1,0,0}}
matrix3x3perm :: Num a => Matrix FinNum3 a
matrix3x3perm = matrix value
 where
  value (FinNum3 1 :-> FinNum3 1) = 0
  value (FinNum3 1 :-> FinNum3 2) = 1
  value (FinNum3 1 :-> FinNum3 3) = 0
  value (FinNum3 2 :-> FinNum3 1) = 0
  value (FinNum3 2 :-> FinNum3 2) = 0
  value (FinNum3 2 :-> FinNum3 3) = 1
  value (FinNum3 3 :-> FinNum3 1) = 1
  value (FinNum3 3 :-> FinNum3 2) = 0
  value (FinNum3 3 :-> FinNum3 3) = 0

--λ> printMatrix $ matrix3x3perm
--0 1 0
--0 0 1
--1 0 0

--λ> printMatrix . transpose $ matrix3x3perm
--0 0 1
--1 0 0
--0 1 0
