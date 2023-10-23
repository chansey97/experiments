module A_Very_General_Method_Of_Computing_Shortest_Paths.RegexGraph where

import Data.Array
import Data.Maybe
import Data.List
import Control.Applicative
import Control.Monad

import A_Very_General_Method_Of_Computing_Shortest_Paths.Matrix
import A_Very_General_Method_Of_Computing_Shortest_Paths.StarSemiring
import A_Very_General_Method_Of_Computing_Shortest_Paths.RegexExpression

reGraph :: (Ix i) => Matrix i (Maybe a) -> Matrix i (RE a)
reGraph = fmap (maybe zero re)


