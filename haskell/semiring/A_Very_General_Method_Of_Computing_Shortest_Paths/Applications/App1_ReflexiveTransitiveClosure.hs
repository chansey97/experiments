module A_Very_General_Method_Of_Computing_Shortest_Paths.Applications.App1_ReflexiveTransitiveClosure where

import Data.Array
import Data.Maybe
import Data.List
import Control.Applicative
import Control.Monad

import A_Very_General_Method_Of_Computing_Shortest_Paths.StarSemiring
import A_Very_General_Method_Of_Computing_Shortest_Paths.Matrix
import A_Very_General_Method_Of_Computing_Shortest_Paths.MatrixOverStarSemiring

import A_Very_General_Method_Of_Computing_Shortest_Paths.Graph
import A_Very_General_Method_Of_Computing_Shortest_Paths.RegexExpression
import A_Very_General_Method_Of_Computing_Shortest_Paths.RegexGraph

---- # Reflexive-transitive closure of a directed graph ----

data Node = A | B | C | D | E deriving (Eq, Ord, Bounded, Ix, Show)

exampleGraph :: Graph Node
exampleGraph = graph [(A :-> B), (B :-> C), (C :-> D), (C :-> E), (D :-> B), (E :-> D)]

--λ> printMatrix exampleGraph
--0 * 0 0 0
--0 0 * 0 0
--0 0 0 * *
--0 * 0 0 0
--0 0 0 * 0

-- turn Connection (edge value) into a *-semiring

instance Semiring Connection where
  zero = Unconnected
  Connected   <+> _ = Connected
  Unconnected <+> x = x
  one = Connected
  Unconnected <.> _ = Unconnected
  Connected   <.> x = x

instance StarSemiring Connection where
  star _ = one

instance KleeneAlgebra Connection where

-- ## Compute the reflexive-transitive closure using x*

-- λ> printMatrix . star $ exampleGraph
-- * * * * *
-- 0 * * * *
-- 0 * * * *
-- 0 * * * *
-- 0 * * * *

-- ## Compute just the transitive closure we simply compute x+.

-- λ> printMatrix . plus $ exampleGraph
-- 0 * * * *
-- 0 * * * *
-- 0 * * * *
-- 0 * * * *
-- 0 * * * *

-- ## Compute paths via regular expression ----

--λ> printMatrix . labelGraph $ exampleGraph
--Nothing Just (AB) Nothing   Nothing   Nothing
--Nothing Nothing   Just (BC) Nothing   Nothing
--Nothing Nothing   Nothing   Just (CD) Just (CE)
--Nothing Just (DB) Nothing   Nothing   Nothing
--Nothing Nothing   Nothing   Just (ED) Nothing

--λ> printMatrix . labelGraph $ star exampleGraph
--Just (AA) Just (AB) Just (AC) Just (AD) Just (AE)
--Nothing   Just (BB) Just (BC) Just (BD) Just (BE)
--Nothing   Just (CB) Just (CC) Just (CD) Just (CE)
--Nothing   Just (DB) Just (DC) Just (DD) Just (DE)
--Nothing   Just (EB) Just (EC) Just (ED) Just (EE)

-- λ> printMatrix . reGraph . labelGraph $ exampleGraph
-- 0 (AB) 0    0    0
-- 0 0    (BC) 0    0
-- 0 0    0    (CD) (CE)
-- 0 (DB) 0    0    0
-- 0 0    0    (ED) 0

-- λ> printMatrix . star . reGraph . labelGraph $ exampleGraph
-- ε    (AB)|(AB)((BC)((CD)|(CE)(ED))(DB))*(BC)((CD)|(CE)(ED))(DB)                                         (AB)((BC)((CD)|(CE)(ED))(DB))*(BC)                         (AB)((BC)((CD)|(CE)(ED))(DB))*(BC)((CD)|(CE)(ED))                                        (AB)((BC)((CD)|(CE)(ED))(DB))*(BC)(CE)
-- 0    ε|(BC)((CD)|(CE)(ED))(DB)|(BC)((CD)|(CE)(ED))(DB)((BC)((CD)|(CE)(ED))(DB))*(BC)((CD)|(CE)(ED))(DB) (BC)|(BC)((CD)|(CE)(ED))(DB)((BC)((CD)|(CE)(ED))(DB))*(BC) (BC)((CD)|(CE)(ED))|(BC)((CD)|(CE)(ED))(DB)((BC)((CD)|(CE)(ED))(DB))*(BC)((CD)|(CE)(ED)) (BC)(CE)|(BC)((CD)|(CE)(ED))(DB)((BC)((CD)|(CE)(ED))(DB))*(BC)(CE)
-- 0    ((CD)|(CE)(ED))(DB)|((CD)|(CE)(ED))(DB)((BC)((CD)|(CE)(ED))(DB))*(BC)((CD)|(CE)(ED))(DB)           ε|((CD)|(CE)(ED))(DB)((BC)((CD)|(CE)(ED))(DB))*(BC)        (CD)|(CE)(ED)|((CD)|(CE)(ED))(DB)((BC)((CD)|(CE)(ED))(DB))*(BC)((CD)|(CE)(ED))           (CE)|((CD)|(CE)(ED))(DB)((BC)((CD)|(CE)(ED))(DB))*(BC)(CE)
-- 0    (DB)|(DB)((BC)((CD)|(CE)(ED))(DB))*(BC)((CD)|(CE)(ED))(DB)                                         (DB)((BC)((CD)|(CE)(ED))(DB))*(BC)                         ε|(DB)((BC)((CD)|(CE)(ED))(DB))*(BC)((CD)|(CE)(ED))                                      (DB)((BC)((CD)|(CE)(ED))(DB))*(BC)(CE)
-- 0    (ED)(DB)|(ED)(DB)((BC)((CD)|(CE)(ED))(DB))*(BC)((CD)|(CE)(ED))(DB)                                 (ED)(DB)((BC)((CD)|(CE)(ED))(DB))*(BC)                     (ED)|(ED)(DB)((BC)((CD)|(CE)(ED))(DB))*(BC)((CD)|(CE)(ED))                               ε|(ED)(DB)((BC)((CD)|(CE)(ED))(DB))*(BC)(CE)
--
