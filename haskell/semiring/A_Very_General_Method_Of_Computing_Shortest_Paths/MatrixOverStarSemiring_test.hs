module A_Very_General_Method_Of_Computing_Shortest_Paths.MatrixOverStarSemiring_test where

import Data.Array
import Data.Maybe
import Data.List hiding (transpose)
import Control.Applicative
import Control.Monad

import A_Very_General_Method_Of_Computing_Shortest_Paths.StarSemiring
import A_Very_General_Method_Of_Computing_Shortest_Paths.Matrix
import A_Very_General_Method_Of_Computing_Shortest_Paths.MatrixOverStarSemiring

data FinNum3 = FinNum3 Int
             deriving (Ix, Eq, Ord, Show)

instance Bounded FinNum3 where
  minBound = FinNum3 1
  maxBound = FinNum3 3

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

instance Semiring Double where
  zero = 0
  (<+>) = (+)
  one = 1
  (<.>) = (*)

---- matrix multiplication

-- left multiplication permutation matrix, i.e. row exchange
-- λ> printMatrix $ matrix3x3perm <.> matrix3x3
-- 28.0 7.0  2.0
-- 5.0  1.0  0.0
-- 0.0  15.0 3.0

-- right multiplication permutation matrix, i.e. column exchange
-- λ> printMatrix $ matrix3x3 <.> matrix3x3perm
-- 3.0 0.0  15.0
-- 2.0 28.0 7.0
-- 0.0 5.0  1.0



