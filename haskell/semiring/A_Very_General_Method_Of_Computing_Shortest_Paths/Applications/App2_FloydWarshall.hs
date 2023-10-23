module A_Very_General_Method_Of_Computing_Shortest_Paths.Applications.App2_FloydWarshall where

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

---- # All pairs of shorest path (Floyd-Warshall algorithm)

-- We will take our example graph from the Wikipedia page for Dijkstra's algorithm
-- http://en.wikipedia.org/w/index.php?title=Dijkstra%27s_algorithm&oldid=443411519
-- 算法并非 Dijkstra's algorithm, 只是利用 wikipedia 里的图片作为例子

data Node2 = N1 | N2 | N3 | N4 | N5 | N6
             deriving (Eq, Ord, Bounded, Ix, Show)

exampleEdgeList2 :: (Edge Node2) -> Maybe Integer
exampleEdgeList2 (i :-> j) =
  (lookup (i :-> j) edges) `mplus` (lookup (j :-> i) edges)
 where
  edges = [(N1 :-> N2, 7), (N1 :-> N3, 9), (N1 :-> N6,14)
          ,(N2 :-> N3,10), (N2 :-> N4,15)
          ,(N3 :-> N4,11), (N3 :-> N6, 2)
          ,(N4 :-> N5, 6)
          ,(N5 :-> N6, 9)
          ]

exampleGraph2 :: Matrix Node2 (Maybe Integer)
exampleGraph2 = matrix exampleEdgeList2

-- λ> printMatrix $ exampleGraph2
-- Nothing Just 7  Just 9  Nothing Nothing Just 14
-- Just 7  Nothing Just 10 Just 15 Nothing Nothing
-- Just 9  Just 10 Nothing Just 11 Nothing Just 2
-- Nothing Just 15 Just 11 Nothing Just 6  Nothing
-- Nothing Nothing Nothing Just 6  Nothing Just 9
-- Just 14 Nothing Just 2  Nothing Just 9  Nothing

data Tropical a = Tropical a
                | Infinity deriving (Eq, Ord)

instance (Ord a, Num a) => Semiring (Tropical a) where
  zero = Infinity
  Infinity     <+> y            = y
  x            <+> Infinity     = x
  (Tropical a) <+> (Tropical b) = Tropical (min a b)
  one = Tropical 0
  Infinity <.> _ = Infinity
  _ <.> Infinity = Infinity
  (Tropical x) <.> (Tropical y) = Tropical (x + y)


instance (Ord a, Num a) => StarSemiring (Tropical a) where
  star _ = one


instance (Ord a, Num a) => KleeneAlgebra (Tropical a) where

instance Show a => Show (Tropical a) where
  show (Tropical a) = show a
  show Infinity = "∞"

-- We can convert the labels in our example matrix to tropical values.

-- λ> printMatrix . fmap (maybe zero Tropical) $ exampleGraph2
-- ∞  7  9  ∞  ∞ 14
-- 7  ∞  10 15 ∞ ∞
-- 9  10 ∞  11 ∞ 2
-- ∞  15 11 ∞  6 ∞
-- ∞  ∞  ∞  6  ∞ 9
-- 14 ∞  2  ∞  9 ∞

-- The asteration of this tropical matrix will then tell us the minimum distance between any two nodes in the graph.

-- λ> printMatrix . star . fmap (maybe zero Tropical) $ exampleGraph2
-- 0  7  9  20 20 11
-- 7  0  10 15 21 12
-- 9  10 0  11 11 2
-- 20 15 11 0  6  13
-- 20 21 11 6  0  9
-- 11 12 2  13 9  0

-- ## Compute paths via regular expression ----

data ShortestPath a b = ShortestPath (Tropical a) b

instance Functor (ShortestPath a) where
  fmap f (ShortestPath a x) = ShortestPath a (f x)

extract :: ShortestPath a b -> b
extract (ShortestPath _ x) = x

instance (Show a, Show b) => Show (ShortestPath a b) where
  show (ShortestPath a x) = show x ++ "[" ++ show a ++ "]"

instance (Ord a, Num a, Semiring b) => Semiring (ShortestPath a b) where
  zero = ShortestPath zero zero
  ShortestPath a x <+> ShortestPath b y | c < b = ShortestPath a x
                                        | c < a = ShortestPath b y
                                        -- In case both tropical values are equal, then we take both pieces of ancillary data together by adding them.
                                        | otherwise = ShortestPath c (x <+> y)
   where
    c = a <+> b
  one = ShortestPath one one
  ShortestPath a x <.> ShortestPath b y = ShortestPath (a <.> b) (x <.> y)

-- The star operation simply returns one (which is the tropical value 0) in almost all cases.
-- However, when the tropical value is already one (which is the tropical value 0), we can freely sequence this value as many times as we want.
instance (Ord a, Num a, StarSemiring b) => StarSemiring (ShortestPath a b) where
  star (ShortestPath x b) | x == one  = ShortestPath one (star b)
                          | otherwise = ShortestPath one one

instance (Ord a, Num a, KleeneAlgebra b) => KleeneAlgebra (ShortestPath a b) where

annotate :: (Ix i, Bounded i, Ord a, Num a, Semiring b) =>
            ((Edge i) -> b) -> Matrix i (Maybe a) -> Matrix i (ShortestPath a b)
annotate f m = go <$> m <*> labelGraph (connect m) -- go <$> ... 利用 applicative, 把 m 里的 (Maybe Integer) 变成 (ShortestPath (Tropical Integer) (RE Node2))
 where
  go v e = ShortestPath (maybe zero Tropical v) (maybe zero f e)

--λ> printMatrix . labelGraph . connect $ exampleGraph2
--Nothing     Just (N1N2) Just (N1N3) Nothing     Nothing     Just (N1N6)
--Just (N2N1) Nothing     Just (N2N3) Just (N2N4) Nothing     Nothing
--Just (N3N1) Just (N3N2) Nothing     Just (N3N4) Nothing     Just (N3N6)
--Nothing     Just (N4N2) Just (N4N3) Nothing     Just (N4N5) Nothing
--Nothing     Nothing     Nothing     Just (N5N4) Nothing     Just (N5N6)
--Just (N6N1) Nothing     Just (N6N3) Nothing     Just (N6N5) Nothing

--λ> printMatrix . star . annotate re $ exampleGraph2
--ε[0]                   (N1N2)[7]                           (N1N3)[9]        (N1N3)(N3N4)[20] (N1N3)(N3N6)(N6N5)[20]              (N1N3)(N3N6)[11]
--(N2N1)[7]              ε[0]                                (N2N3)[10]       (N2N4)[15]       (N2N4)(N4N5)|(N2N3)(N3N6)(N6N5)[21] (N2N3)(N3N6)[12]
--(N3N1)[9]              (N3N2)[10]                          ε[0]             (N3N4)[11]       (N3N6)(N6N5)[11]                    (N3N6)[2]
--(N4N3)(N3N1)[20]       (N4N2)[15]                          (N4N3)[11]       ε[0]             (N4N5)[6]                           (N4N3)(N3N6)[13]
--(N5N6)(N6N3)(N3N1)[20] (N5N4)(N4N2)|(N5N6)(N6N3)(N3N2)[21] (N5N6)(N6N3)[11] (N5N4)[6]        ε[0]                                (N5N6)[9]
--(N6N3)(N3N1)[11]       (N6N3)(N3N2)[12]                    (N6N3)[2]        (N6N3)(N3N4)[13] (N6N5)[9]                           ε[0]

-- Check http://en.wikipedia.org/w/index.php?title=Dijkstra%27s_algorithm&oldid=443411519
-- 正确：(N5N4)(N4N2)|(N5N6)(N6N3)(N3N2)[21]
-- Node5 到 Node2 有两条最短路，权值均为 21，这里我们把这两条最短路都枚举了出来！

-- ## Compute only one path via regular language (lazy list) ----

-- Having a regular expression of paths is nice, but what if we want to just find one shortest path.
-- What we can do is compute a lazy list of all shortest paths and take the first one. We call a lazy list of lists of labels a Language and it is our next example of a *-semiring.
-- We call a lazy list of lists of labels a Language and it is our next example of a *-semiring.

-- 正则语言 Language 的构造 see Introduction to Automata Theory, Languages, and Computation 2ed 中文版 p.57 一模一样
newtype Language a = Language [[a]] deriving Show

letter x = Language [[x]]

instance Semiring (Language a) where
  zero = Language []
  (Language x) <+> (Language y) = Language (x `interleave` y)
   where
    []     `interleave` ys = ys
    (x:xs) `interleave` ys = x:(ys `interleave` xs)
  one = Language (pure [])
  (Language x) <.> (Language y) = Language (dovetail (++) x y)
   where
    dovetail f l1 l2 = concat $ go l1 (scanl (flip (:)) [] l2)
     where
      go [] _           = []
      go l1 l2@(x:y:ys) = (zipWith f l1 x):(go l1 (y:ys))
      go l1@(a:as) [x]  = (zipWith f l1 x):(go as [x])

instance StarSemiring (Language a) where
  star (Language l) = one <+> plusList (filter (not . null) l)
   where
    plusList [] = zero
    plusList l  = star (Language l) <.> (Language l)

-- 关于 Semiring (Language a) 的一些 debugging:

-- λ> :{
-- go [] _           = []
-- go l1 l2@(x:y:ys) = (zipWith (++) l1 x):(go l1 (y:ys))
-- go l1@(a:as) [x]  = (zipWith (++) l1 x):(go as [x])
-- :}

-- λ> go ["123","456", "789"] (scanl (flip (:)) [] ["abc", "def", "ghj"])
-- [[],["123abc"],["123def","456abc"],["123ghj","456def","789abc"],["456ghj","789def"],["789ghj"]]
--
-- λ> concat $ go ["123","456", "789"] (scanl (flip (:)) [] ["abc", "def", "ghj"])
-- ["123abc","123def","456abc","123ghj","456def","789abc","456ghj","789def","789ghj"]

instance KleeneAlgebra (Language a) where

someWord :: Language a -> Maybe [a]
someWord (Language l) = listToMaybe l

-- λ> printMatrix . star . annotate letter $ exampleGraph2
-- Language [[]][0]                      Language [[(N1N2)]][7]                                Language [[(N1N3)]][9]         Language [[(N1N3),(N3N4)]][20] Language [[(N1N3),(N3N6),(N6N5)]][20]                 Language [[(N1N3),(N3N6)]][11]
-- Language [[(N2N1)]][7]                Language [[]][0]                                      Language [[(N2N3)]][10]        Language [[(N2N4)]][15]        Language [[(N2N4),(N4N5)],[(N2N3),(N3N6),(N6N5)]][21] Language [[(N2N3),(N3N6)]][12]
-- Language [[(N3N1)]][9]                Language [[(N3N2)]][10]                               Language [[]][0]               Language [[(N3N4)]][11]        Language [[(N3N6),(N6N5)]][11]                        Language [[(N3N6)]][2]
-- Language [[(N4N3),(N3N1)]][20]        Language [[(N4N2)]][15]                               Language [[(N4N3)]][11]        Language [[]][0]               Language [[(N4N5)]][6]                                Language [[(N4N3),(N3N6)]][13]
-- Language [[(N5N6),(N6N3),(N3N1)]][20] Language [[(N5N4),(N4N2)],[(N5N6),(N6N3),(N3N2)]][21] Language [[(N5N6),(N6N3)]][11] Language [[(N5N4)]][6]         Language [[]][0]                                      Language [[(N5N6)]][9]
-- Language [[(N6N3),(N3N1)]][11]        Language [[(N6N3),(N3N2)]][12]                        Language [[(N6N3)]][2]         Language [[(N6N3),(N3N4)]][13] Language [[(N6N5)]][9]                                Language [[]][0]

-- λ> printMatrix . fmap (someWord . extract) . star . annotate letter $ exampleGraph2
-- Just []                     Just [(N1N2)]        Just [(N1N3)]        Just [(N1N3),(N3N4)] Just [(N1N3),(N3N6),(N6N5)] Just [(N1N3),(N3N6)]
-- Just [(N2N1)]               Just []              Just [(N2N3)]        Just [(N2N4)]        Just [(N2N4),(N4N5)]        Just [(N2N3),(N3N6)]
-- Just [(N3N1)]               Just [(N3N2)]        Just []              Just [(N3N4)]        Just [(N3N6),(N6N5)]        Just [(N3N6)]
-- Just [(N4N3),(N3N1)]        Just [(N4N2)]        Just [(N4N3)]        Just []              Just [(N4N5)]               Just [(N4N3),(N3N6)]
-- Just [(N5N6),(N6N3),(N3N1)] Just [(N5N4),(N4N2)] Just [(N5N6),(N6N3)] Just [(N5N4)]        Just []                     Just [(N5N6)]
-- Just [(N6N3),(N3N1)]        Just [(N6N3),(N3N2)] Just [(N6N3)]        Just [(N6N3),(N3N4)] Just [(N6N5)]               Just []


-- ## Two steps methods: First compute asteration of a regular expression matrix, then collapse it to Tropical! ----

-- Recall that I said that regular expressions were the mother of all Kleene algebras.
-- What I mean by this is that regular expressions can interpret any other Kleene algebra if we have an interpretation for the variables.
-- regular expressions 类似一个 free algebra, 其他 Kleene algebra 都可以 regular expressions collapse 得到

-- This means that instead of computing the asteration of a matrices of different values that we are interested in, we can compute one matrix
-- of regular expressions and then interpret that matrix in any Kleene algebra to get the same result.

evalRE :: (KleeneAlgebra a) => (l -> a) -> RE l -> a
evalRE f (RE None)        = zero
evalRE f (RE Empty)       = one
evalRE f (RE (Var a))     = f a
evalRE f (RE (Star x))    = star (evalRE f (RE x))
evalRE f (RE (x `Or` y))  = (evalRE f (RE x)) <+> (evalRE f (RE y))
evalRE f (RE (x `Seq` y)) = (evalRE f (RE x)) <.> (evalRE f (RE y))

-- 把矩阵 component 的正则表达式解释为 Tropical
-- λ> printMatrix . fmap (evalRE Tropical) . star . reGraph $ exampleGraph2
-- 0  7  9  20 20 11
-- 7  0  10 15 21 12
-- 9  10 0  11 11 2
-- 20 15 11 0  6  13
-- 20 21 11 6  0  9
-- 11 12 2  13 9  0






