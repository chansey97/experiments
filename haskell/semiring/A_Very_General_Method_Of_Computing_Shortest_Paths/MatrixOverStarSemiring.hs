module A_Very_General_Method_Of_Computing_Shortest_Paths.MatrixOverStarSemiring where

import Data.Array
import Data.Maybe
import Data.List
import Control.Applicative
import Control.Monad

import A_Very_General_Method_Of_Computing_Shortest_Paths.StarSemiring
import A_Very_General_Method_Of_Computing_Shortest_Paths.Matrix

instance (Ix i, Bounded i, Semiring a) => Semiring (Matrix i a) where
  zero = pure zero
  (<+>) = liftA2 (<+>)
  one = matrix (\(i :-> j) -> if i == j then one else zero) -- 单位矩阵
  Matrix x <.> Matrix y = matrix build
   where
    build (i :-> j) = srsum [x!(i :-> k) <.> y!(k :-> j) | k <- entireRange]


-- Implement plus using the famous Gauss-Jordan-Floyd-Warshall-Kleene algorithm
-- Only for R+, not R*, see Rafael Penaloza - Algebraic Structures for Transitive Closure / Algorithm 4.2
instance (Ix i, Bounded i, StarSemiring a) => StarSemiring (Matrix i a) where
  plus x = foldr f x entireRange
   where
    f k (Matrix m) = matrix build
     where
      build (i :-> j) = m!(i :-> j) <+>
                        m!(i :-> k) <.> star (m!(k :-> k)) <.> m!(k :-> j)

-- We will also note that matricies over a Kleene algebra is itself a Kleene algebra.
instance (Ix i, Bounded i, KleeneAlgebra a) => KleeneAlgebra (Matrix i a) where
