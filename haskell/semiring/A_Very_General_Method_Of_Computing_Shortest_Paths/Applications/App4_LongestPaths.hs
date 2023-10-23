module A_Very_General_Method_Of_Computing_Shortest_Paths.Applications.App4_LongestPaths where

import Data.Array
import Data.Maybe
import Data.List
import Control.Applicative
import Control.Monad

import A_Very_General_Method_Of_Computing_Shortest_Paths.StarSemiring
import A_Very_General_Method_Of_Computing_Shortest_Paths.Matrix
import A_Very_General_Method_Of_Computing_Shortest_Paths.MatrixOverStarSemiring

import A_Very_General_Method_Of_Computing_Shortest_Paths.StarSemiringExpression
import A_Very_General_Method_Of_Computing_Shortest_Paths.Graph
import A_Very_General_Method_Of_Computing_Shortest_Paths.RegexExpression
import A_Very_General_Method_Of_Computing_Shortest_Paths.RegexGraph

---- ## All pairs of longest path, see Fun with Semirings.pdf

data LongestDistance = LDistance Integer
                     | LUnreachable
                     | LInfinite
                     deriving (Eq, Ord)

instance Semiring (LongestDistance) where
  -- <+>
  zero = LUnreachable
  x     <+> LUnreachable            = x
  LUnreachable     <+> y            = y
  LInfinite <+> _                   = LInfinite
  _            <+> LInfinite     = LInfinite
  (LDistance a) <+> (LDistance b) = LDistance (max a b)
  -- <.>
  one = LDistance 0
  _ <.> LUnreachable = LUnreachable
  LUnreachable <.> _ = LUnreachable
  _ <.> LInfinite = LInfinite
  LInfinite <.> _ = LInfinite -- I added this rules for non-DAG
  (LDistance x) <.> (LDistance y) = LDistance (x + y)


instance StarSemiring LongestDistance where
  star LUnreachable = LDistance 0
  star (LDistance 0) = LDistance 0
  star _ = LInfinite


instance KleeneAlgebra LongestDistance where

instance Show LongestDistance where
  show (LDistance a) = show a
  show LUnreachable = "unreach"
  show LInfinite = "inf"

-- Example of DAG, see https://math.stackexchange.com/questions/3422852/find-longest-path-in-weighted-graph

data Node3 = N1 | N2 | N3 | N4 | N5 | N6 | N7
             deriving (Eq, Ord, Bounded, Ix, Show)

exampleEdgeList3 :: (Edge Node3) -> Maybe Integer
exampleEdgeList3 (i :-> j) =
  (lookup (i :-> j) edges)
 where
  edges = [(N1 :-> N4, 1), (N1 :-> N5, 1)
          ,(N2 :-> N3, 1), (N2 :-> N7, 1)
          ,(N3 :-> N4, 1), (N3 :-> N6, 1)
          ,(N4 :-> N5, 1), (N4 :-> N6, 1)
          ,(N5 :-> N6, 1)
          ,(N6 :-> N7, 1)
          ]


exampleGraph3 :: Matrix Node3 (Maybe Integer)
exampleGraph3 = matrix exampleEdgeList3

-- λ> printMatrix $ exampleGraph3
-- Nothing Nothing Nothing Just 1  Just 1  Nothing Nothing
-- Nothing Nothing Just 1  Nothing Nothing Nothing Just 1
-- Nothing Nothing Nothing Just 1  Nothing Just 1  Nothing
-- Nothing Nothing Nothing Nothing Just 1  Just 1  Nothing
-- Nothing Nothing Nothing Nothing Nothing Just 1  Nothing
-- Nothing Nothing Nothing Nothing Nothing Nothing Just 1
-- Nothing Nothing Nothing Nothing Nothing Nothing Nothing

--λ> printMatrix . fmap (maybe zero LDistance) $ exampleGraph3
--unreach unreach unreach 1       1       unreach unreach
--unreach unreach 1       unreach unreach unreach 1
--unreach unreach unreach 1       unreach 1       unreach
--unreach unreach unreach unreach 1       1       unreach
--unreach unreach unreach unreach unreach 1       unreach
--unreach unreach unreach unreach unreach unreach 1
--unreach unreach unreach unreach unreach unreach unreach

-- 对角线是 0, 说明了没有环, 因为这个 0 实际上是 I <+> R+ 的 I
-- 如果有环, 则对角线元素就会有 Distence 从而 star 后变成了 inf

--λ> printMatrix . star . fmap (maybe zero LDistance) $ exampleGraph3
--0       unreach unreach 1       2       3       4
--unreach 0       1       2       3       4       5
--unreach unreach 0       1       2       3       4
--unreach unreach unreach 0       1       2       3
--unreach unreach unreach unreach 0       1       2
--unreach unreach unreach unreach unreach 0       1
--unreach unreach unreach unreach unreach unreach 0

-- Example of non-DAG, i.e. if the directed graph has circle?
exampleEdgeList3_circle :: (Edge Node3) -> Maybe Integer
exampleEdgeList3_circle (i :-> j) =
  (lookup (i :-> j) edges)
 where
  edges = [(N1 :-> N4, 1), (N5 :-> N1, 1) --, (N1 :-> N5, 1) -- manually create a circle
          ,(N2 :-> N3, 1), (N2 :-> N7, 1)
          ,(N3 :-> N4, 1), (N3 :-> N6, 1)
          ,(N4 :-> N5, 1), (N4 :-> N6, 1)
          ,(N5 :-> N6, 1)
          ,(N6 :-> N7, 1)
          ]

exampleGraph3_circle :: Matrix Node3 (Maybe Integer)
exampleGraph3_circle = matrix exampleEdgeList3_circle


--λ> printMatrix $ exampleGraph3_circle
--Nothing Nothing Nothing Just 1  Nothing Nothing Nothing
--Nothing Nothing Just 1  Nothing Nothing Nothing Just 1
--Nothing Nothing Nothing Just 1  Nothing Just 1  Nothing
--Nothing Nothing Nothing Nothing Just 1  Just 1  Nothing
--Just 1  Nothing Nothing Nothing Nothing Just 1  Nothing
--Nothing Nothing Nothing Nothing Nothing Nothing Just 1
--Nothing Nothing Nothing Nothing Nothing Nothing Nothing


--λ> printMatrix . fmap (maybe zero LDistance) $ exampleGraph3_circle
--unreach unreach unreach 1       unreach unreach unreach
--unreach unreach 1       unreach unreach unreach 1
--unreach unreach unreach 1       unreach 1       unreach
--unreach unreach unreach unreach 1       1       unreach
--1       unreach unreach unreach unreach 1       unreach
--unreach unreach unreach unreach unreach unreach 1
--unreach unreach unreach unreach unreach unreach unreach


--λ> printMatrix . star . fmap (maybe zero LDistance) $ exampleGraph3_circle
--inf     unreach unreach inf     inf     inf     inf
--inf     0       1       inf     inf     inf     inf
--inf     unreach 0       inf     inf     inf     inf
--inf     unreach unreach inf     inf     inf     inf
--inf     unreach unreach inf     inf     inf     inf
--unreach unreach unreach unreach unreach 0       1
--unreach unreach unreach unreach unreach unreach 0

-- 可见, 对于有环图, 路径可能无限长
