-- 1. Power series, power serious by M. DOUGLAS MCILROY, A Collected code.
-- 2. https://www.cs.dartmouth.edu/~doug/powser2.txt

module Power_series_power_serious.PowerSeries where

--import Prelude hiding (sqrt)

--import Ratio
infixl 7 .*
default (Integer, Rational, Double)

---- constant series
ps0, x:: Num a => [a]
ps0 = 0 : ps0
x = 0 : 1 : ps0

---- arithmetic

-- 标量的乘法
(.*):: Num a => a->[a]->[a]
c .* (f:fs) = c*f : c.*fs

-- 级数的加法、卷积
instance (Num a, Eq a) => Num [a] where
  fromInteger c = fromInteger c : ps0
  negate (f:fs) = (negate f) : (negate fs)
  (f:fs) + (g:gs) = f+g : fs+gs
  (f:fs) * (g:gs) = f*g : (f.*gs + fs*(g:gs))
  signum _ = error "signum not implemented for Num [a]"
  abs _ = error "abs not implemented for Num [a]"

-- 级数的除法
instance (Fractional a, Eq a) => Fractional [a] where
  fromRational c = fromRational c : ps0
  recip fs = 1/fs
  (0:fs) / (0:gs) = fs/gs
  (f:fs) / (g:gs) = let q = f/g in
                        q : (fs - q.*gs)/(g:gs)

-- functional composition
-- 级数的 compose
compose:: (Num a, Eq a) => [a]->[a]->[a]
compose (f:fs) (0:gs) = f : gs*(compose fs (0:gs))

-- 级数的反演
revert::(Fractional a, Eq a) => [a]->[a]
revert (0:fs) = rs where
  rs = 0 : 1/(compose fs rs)

---- calculus

-- 级数的导函数
deriv:: Num a => [a]->[a]
deriv (f:fs) = (deriv1 fs 1) where
  deriv1 (g:gs) n = n*g : (deriv1 gs (n+1))

-- 级数的 ∫₀ˣ 定积分函数
integral:: Fractional a => [a]->[a]
integral fs = 0 : (int1 fs 1) where
  int1 (g:gs) n = g/n : (int1 gs (n+1))

---- Solving differential equations by Picard's method
expx, cosx, sinx:: (Fractional a, Eq a) => [a]
expx = 1 + (integral expx)
sinx = integral cosx
cosx = 1 - (integral sinx)

-- Haskell normally places sqrt in type class Floating; the collected code in the appendix complies.
-- Nevertheless, when the square root of a series with rational
-- coefficients can be computed, the result will have rational coecoefficients

-- square root of a f(x) series
instance (Fractional a, Eq a) => Floating [a] where
  sqrt (0:0:fs) = 0 : sqrt fs
  sqrt (1:fs) = qs where
    qs = 1 + integral((deriv (1:fs))/(2.*qs))
  pi = error "pi not implemented for Floating [a]"
  exp = error "exp not implemented for Floating [a]"
  log = error "log not implemented for Floating [a]"
  sin = error "sin not implemented for Floating [a]"
  cos = error "cos not implemented for Floating [a]"
  asin = error "asin not implemented for Floating [a]"
  acos = error "acos not implemented for Floating [a]"
  atan = error "atan not implemented for Floating [a]"
  sinh = error "sinh not implemented for Floating [a]"
  cosh = error "cosh not implemented for Floating [a]"
  asinh = error "asinh not implemented for Floating [a]"
  acosh = error "acosh not implemented for Floating [a]"
  atanh = error "atanh not implemented for Floating [a]"

---- tests

-- Checking many terms of sinx against sqrt(1-cosx^2) exercises most of the arithmetic and calculus functions.
-- sinx = sqrt(1 - (cosx)^2)
test1 = sinx - sqrt(1-cosx^2)

-- Checking tan x, computed as sin x= cos x, against the functional inverse of arctan x, computed as ∫(1/(1 + x²)) dx
-- sinx / cosx = tanx = inverse of arctanx, where arctanx = ∫₀ˣ (1/(1 + t²)) dt
test2 = sinx/cosx - revert(integral(1/(1+x^2)))

-- The checks can be carried out to 30 terms in a few seconds
iszero n fs = (take n fs) == (take n ps0)

-- main
main = (iszero 30 test1) && (iszero 30 test2)

--λ> main
--True


---- generating functions

-- Binary trees
ts = 1 : ts^2

-- Evaluating ts yields the Catalan numbers, as it should (Knuth 1968):

-- λ> take 10 ts
-- [1,1,2,5,14,42,132,429,1430,4862]

-- Ordered trees
tree = 0 : forest
forest = compose list tree
list = 1 : list

-- Catalan numbers again! The apparent identity between the number of binary trees
-- on n nodes and the number of nonempty ordered trees on n+1 nodes is real (Knuth, 1968):
-- a little algebra confirms that tree = xT.

-- λ> take 10 tree
-- [0,1,1,2,5,14,42,132,429,1430]


-- Fibonacci

-- 1. Derive the generating function of Fibonacci

-- 先写出 fib 序列的递归式
fib = 0 : 1 : zipWith (+) fib (tail fib)

-- λ> take 10 fib
-- [0,1,1,2,3,5,8,13,21,34]

-- 观察上述 fib 定义，把序列 fib 看成 power series of F(x), 利用 p.326:
-- > head/tail decomposition of power series maps naturally into the head/tail decomposition of lists.
-- > F(x) = f0 + x F1(x)

-- 得到: F(x) = 0 + x + x^2 F(x) + x F(x)
-- 注意：在 zipWith (+) fib (tail fib) 里,
-- 第一个 fib 需要向右平移两位, 正好加到第 3 个位置, 因此是 x^2 F(x)
-- 第二个 tail fib 只需要向右平移一位，因为 (tail fib) 本质上使 fib 向左平移了一位, 然后再加到第 3 个位置, 因此是 x^2 (1/x) F(x) = x F(X)


-- 移项化简：
-- F(x) = x / (1 - x - x^2)
-- F(x) 就是生成函数 fibgen(x)

-- 2. Using the generating function fibgen(x) = x / (1 - x - x^2) to produce fib 序列

-- 由于现在 series 作为 algebra, 可以直接写出 fibgenx
fibgenx = x / (1 - x - x^2)

-- λ> take 10 fibgenx
-- [0 % 1,1 % 1,1 % 1,2 % 1,3 % 1,5 % 1,8 % 1,13 % 1,21 % 1,34 % 1]


---- Other tests

one = 1 / (1-x)
--λ> take 10 one
--[1 % 1,1 % 1,1 % 1,1 % 1,1 % 1,1 % 1,1 % 1,1 % 1,1 % 1,1 % 1]

nat = 1 / (1-x)^2
--λ> take 10 nat
--[1 % 1,2 % 1,3 % 1,4 % 1,5 % 1,6 % 1,7 % 1,8 % 1,9 % 1,10 % 1]



