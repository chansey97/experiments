module SICP.DifferentialEquation where

-- SICP 3.5.4 Streams and Delayed Evaluation

scale :: [Double] -> Double -> [Double]
scale xs factor = map (\x -> x * factor) xs

integral :: [Double] -> Double -> Double -> [Double]
integral integrand initial_value dt = int where
  int = initial_value : zipWith (+) (scale integrand dt) int

--integral :: [Double] -> Double -> Double -> [Double]
--integral integrand initial_value dt = scanl (+) initial_value scaled where
--  scaled = map (\x -> x * dt) integrand

-- λ> take 10 $ integral [1..4] 0 1
-- [0.0,1.0,3.0,6.0,10.0]


---- Solving y' = f(y), the initial condition y(0) = y0

-- Nice, thanks Haskell!
-- 1. dy is thunked by default, we don't have to delay explicitly lick SICP
-- 2. we don't have to change the integral implementation lick SICP
solve :: (Double -> Double) -> Double -> Double -> [Double]
solve f y0 dt = y where
  y = integral dy y0 dt
  dy = map f y

-- For example, let f(x) = x, y(0) = 1,
-- i.e. solve y' = y with y(0) = 1
-- Solved: y(t) = e^t, see https://www.wolframalpha.com/input?i2d=true&i=y%27+%3D+y%5C%2844%29+y%5C%2840%290%5C%2841%29+%3D+1

--y1 = solve (\y -> y) 1 0.001 !! 1000
--λ> y1
--2.716923932235896

-- solved y
solved_y :: Double -> Double
solved_y t = solve (\y -> y) 1 dt !! round (t*precision) where
  precision = 1000.0
  dt = 1/precision

-- λ> solved_y 1
-- 2.716923932235896


---- Exercise 3.78: Solving y'' - a y' - by = 0, the initial condition y(0) = y0 and y'(0) = dy0

solve_2nd :: Double -> Double -> Double -> Double -> Double -> [Double]
solve_2nd a b y0 dy0 dt= y where
  y = integral dy y0 dt
  dy = integral ddy dy0 dt
  ddy = zipWith (+) (scale y b) (scale dy a)

-- For example, let a=-2, b=3, y(0) = 1, y'(0) = 2,
-- i.e. solve y'' + 2y' - 3y = 0 with y(0) = 1, y'(0) = 2
-- Solved: y(t) = (5 e^t)/4 - 1/4 e^(-3 t), see https://www.wolframalpha.com/input?i2d=true&i=y%27%27+%2B+2y%27+-+3y+%3D+0%5C%2844%29++y%5C%2840%290%5C%2841%29%3D1%5C%2844%29+y%27%5C%2840%290%5C%2841%29%3D2
-- y(1) = 3.3854

solve_2nd_y :: Double -> Double
solve_2nd_y t = solve_2nd (-2) 3 1 2 dt !! round (t*precision) where
  precision = 10000.0
  dt = 1/precision

-- λ> solve_2nd_y 1
-- 3.385241242344665


---- Exercise 3.79: Solving y'' = f(y', y), the initial condition y(0) = y0 and y'(0) = dy0

solve_2nd_generic :: (Double -> Double -> Double) -> Double -> Double -> Double -> [Double]
solve_2nd_generic f y0 dy0 dt= y where
  y = integral dy y0 dt
  dy = integral ddy dy0 dt
  ddy = zipWith f dy y

-- For the previous example, let f(y',y) = -2y' + 3y, y(0) = 1, y'(0) = 2,
-- i.e. solve y'' = -2y' + 3y with y(0) = 1, y'(0) = 2
-- Solved: y(t) = (5 e^t)/4 - 1/4 e^(-3 t), see https://www.wolframalpha.com/input?i2d=true&i=y%27%27+%2B+2y%27+-+3y+%3D+0%5C%2844%29++y%5C%2840%290%5C%2841%29%3D1%5C%2844%29+y%27%5C%2840%290%5C%2841%29%3D2
-- y(1) = 3.3854

solve_2nd_generic_y :: Double -> Double
solve_2nd_generic_y t = solve_2nd_generic (\dy y -> -2*dy + 3*y) 1 2 dt !! round (t*precision) where
  precision = 10000.0
  dt = 1/precision

-- λ> solve_2nd_generic_y 1
-- 3.385241242344665

-- Correct and cool!