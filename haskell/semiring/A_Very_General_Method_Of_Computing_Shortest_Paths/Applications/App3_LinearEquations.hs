module A_Very_General_Method_Of_Computing_Shortest_Paths.Applications.App3_LinearEquations where


import Data.Array
import Data.Maybe
import Data.List
import Control.Applicative
import Control.Monad

import A_Very_General_Method_Of_Computing_Shortest_Paths.StarSemiring
import A_Very_General_Method_Of_Computing_Shortest_Paths.Matrix
import A_Very_General_Method_Of_Computing_Shortest_Paths.MatrixOverStarSemiring

import A_Very_General_Method_Of_Computing_Shortest_Paths.StarSemiringExpression


---- ## Solve linear equations

-- 作者只是实现了矩阵求逆, 并没有直接解线性方程组, 但有了逆矩阵之后，求线性方程组非常简单

-- 矩阵求逆的方法：

-- 如果 A 可逆, 且 A 不包含 ∞,  则 A^-1 = (I-A)*,
-- 如果 A 不可逆, 则 (I-A)* 的结果将包含 ∞

-- 输入一个矩阵 A (显然不可能包含 ∞), 求 (I-A)*,
-- 如果 (I-A)* 不包含 ∞, 则 (I-A)* 就是 A^-1
-- 如果 (I-A)* 包含 ∞, 则 A 未必一定是不可逆的! 这是因为 (I-A)* 的过程本质上类似 Gaussian Jordan elimination solve inverse matrix without pivoting.

-- 换句话说, 为了能完美计算 A 的逆矩阵, 你需要:
-- 1. 先计算一个 permutation matrix 适当安排 A 的主元位置, i.e. 计算 P A
-- 2. 求解 (I-PA)*
-- 3. 对 result 矩阵再右乘 P, i.e. (I-PA)*P
-- 4. A^-1 =  (I-PA)*P

-- 以上问题在 http://r6.ca/blog/20110808T035622Z.html 原文中并没有提到
-- See Lehmann - Algebraic Structures for Transitive Closure, Section 3, Examples of closed semi-rings {R ∪ {∞}, +, ·, *, 0, 1}

-- The last example I want to show is how to solve linear equations.
-- This will also be our first example of a *-semiring that is not a Kleene algebra. If we take the one point compactification of the real line,
-- we can turn it into a *-semiring.The additive and multiplicative operations are the usual addition and multiplication operations.

-- However we need to take care that 0 absorbs all elements under multiplication, including ∞.
data Compact a = Real a
               | Inf

instance (Show a) => Show (Compact a) where
  show (Real a) = show a
  show Inf = "∞"

instance (Eq a, Num a) => Semiring (Compact a) where
  zero = Real 0
  Inf    <+> _      = Inf
  _      <+> Inf    = Inf
  Real x <+> Real y = Real (x + y)
  one = Real 1
  Real 0 <.> _      = Real 0
  _      <.> Real 0 = Real 0
  Inf    <.> _      = Inf
  _      <.> Inf    = Inf
  Real x <.> Real y = Real (x * y)

instance (Eq a, Fractional a) => StarSemiring (Compact a) where
  star (Real 1) = Inf
  star (Real x) = Real (recip (1 - x))
  star Inf      = Inf

--Asteration can be used to invert a matrix A because (1 - A)* = A^-1.
inverse :: (Eq a, Ix i, Bounded i, Fractional a) =>
           Matrix i a -> Matrix i (Compact a)
inverse m = star (one <+> fmap (Real . negate) m)

-- Lets compute the asteration of an 2×2 example matrix.
exampleMatrix :: Num a => Matrix Bool a
exampleMatrix = matrix value
 where
  value (False :-> False) = 2
  value (False :-> True ) = 1
  value (True  :-> False) = 0
  value (True  :-> True ) = 2

-- λ> printMatrix . fmap Real $ exampleMatrix
-- 2 1
-- 0 2
--
-- λ> printMatrix . star . fmap Real $ exampleMatrix
-- -1.0 1.0
-- 0.0  -1.0

-- λ> printMatrix . inverse $ exampleMatrix
-- 0.5 -0.25
-- 0.0 0.5

-- Singular matrix
exampleMatrixSingular :: Num a => Matrix Bool a
exampleMatrixSingular = matrix value
 where
  value (False :-> False) = 2
  value (False :-> True ) = 1
  value (True  :-> False) = 4
  value (True  :-> True ) = 2

--λ> printMatrix . inverse $ exampleMatrixSingular
--inf inf
--inf inf


-- An example of invertible matrix A, but inverse it by (1 - A)* contains ∞
-- https://www.youtube.com/watch?v=fD79MlN_ILc&list=PLYdroRCLMg5MgczmIkeY_XVJiJ5LVDFuh&index=33
-- 0,  15, 3
-- 28, 7,  2
-- 5,  1,  0

data FinNum = FinNum Int
             deriving (Ix, Eq, Ord, Show)

instance Bounded FinNum where
  minBound = FinNum 1
  maxBound = FinNum 3

--{{0,15,3},
--{28,7,2},
--{5,1,0}}
matrixA :: Num a => Matrix FinNum a
matrixA = matrix value
 where
  value (FinNum 1 :-> FinNum 1) = 0
  value (FinNum 1 :-> FinNum 2) = 15
  value (FinNum 1 :-> FinNum 3) = 3
  value (FinNum 2 :-> FinNum 1) = 28
  value (FinNum 2 :-> FinNum 2) = 7
  value (FinNum 2 :-> FinNum 3) = 2
  value (FinNum 3 :-> FinNum 1) = 5
  value (FinNum 3 :-> FinNum 2) = 1
  value (FinNum 3 :-> FinNum 3) = 0

--λ> printMatrix . inverse $ matrixA
--inf inf inf
--inf inf inf
--inf inf inf

-- 注意：上述矩阵其实是可逆的, 但这里返回了 inf, 正确的逆矩阵是: (from wolframalpha)
-- -0.0155039 | 0.0232558 | 0.0697674
--  0.0775194 | -0.116279 | 0.651163
-- -0.0542636 | 0.581395 | -3.25581

-- 解决方法: 选定一个 permutation matrix P 通过 row exchange 把 A 的 pivots 排列到正确的位置 PA
--
--    {{0,15,3},       {{0,1,0},          {{28,7,2},
-- A = {28,7,2}, => P = {0,0,1},  => PA =  {5,1,0},
--     {5,1,0}}         {1,0,0}}           {0,15,3}}

--{{0,1,0},
--{0,0,1},
--{1,0,0}}
matrixP :: Num a => Matrix FinNum a
matrixP = matrix value
 where
  value (FinNum 1 :-> FinNum 1) = 0
  value (FinNum 1 :-> FinNum 2) = 1
  value (FinNum 1 :-> FinNum 3) = 0
  value (FinNum 2 :-> FinNum 1) = 0
  value (FinNum 2 :-> FinNum 2) = 0
  value (FinNum 2 :-> FinNum 3) = 1
  value (FinNum 3 :-> FinNum 1) = 1
  value (FinNum 3 :-> FinNum 2) = 0
  value (FinNum 3 :-> FinNum 3) = 0

instance Semiring Double where
  zero = 0
  (<+>) = (+)
  one = 1
  (<.>) = (*)

matrixPA :: Matrix FinNum Double
matrixPA = matrixP <.> matrixA

--λ> printMatrix matrixPA
--28.0 7.0  2.0
--5.0  1.0  0.0
--0.0  15.0 3.0

-- 然后再调用 inverse, 再右乘 P
matrixInverseOfA :: Matrix FinNum (Compact Double)
matrixInverseOfA = (inverse matrixPA) <.> (fmap Real matrixP)

-- λ> printMatrix matrixInverseOfA
-- -1.5503875968992276e-2 2.3255813953483084e-2 6.976744186046524e-2
-- 7.751937984496125e-2   -0.11627906976744207  0.6511627906976745
-- -5.4263565891472965e-2 0.5813953488372086    -3.255813953488372

-- 正确：https://www.wolframalpha.com/input?i2d=true&i=inverse+of+%7B%7B0%2C15%2C3%7D%2C%7B28%2C7%2C2%7D%2C%7B5%2C1%2C0%7D%7D
-- inverse of {{0,15,3},{28,7,2},{5,1,0}}
--
-- (-0.0155039 | 0.0232558 | 0.0697674
-- 0.0775194 | -0.116279 | 0.651163
-- -0.0542636 | 0.581395 | -3.25581)


-- ## Two steps methods: First compute asteration of a semiring matrix, then collapse it to Compact real line! ----

-- Similar to regular expressions, we can interpret any *-semiring expression in any *-semiring.
evalSSE :: (StarSemiring a) => (l -> a) -> StarSemiringExpression l -> a
evalSSE f None        = zero
evalSSE f Empty       = one
evalSSE f (Var a)     = f a
evalSSE f (Star x)    = star (evalSSE f x)
evalSSE f (x `Or` y)  = (evalSSE f x) <+> (evalSSE f y)
evalSSE f (x `Seq` y) = (evalSSE f x) <.> (evalSSE f y)

-- Now, if we want to, we can save an intermediate matrix of *-semiring expressions and interpret it using real numbers,
-- or any other *-semiring (including any Kleene algebra) later.

--λ> printMatrix . fmap (evalSSE Real) . star . fmap Var $ exampleMatrix
---1.0 1.0
--0.0  -1.0
