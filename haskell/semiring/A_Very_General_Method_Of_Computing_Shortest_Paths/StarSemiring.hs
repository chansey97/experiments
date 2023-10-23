module A_Very_General_Method_Of_Computing_Shortest_Paths.StarSemiring where

import Data.Array
import Data.Maybe
import Data.List
import Control.Applicative
import Control.Monad

infixl 6 <+>
infixl 7 <.>

{- Laws:
   a <+> b = b <+> a
   (a <+> b) <+> c = a <+> (b <+> c)
   a <+> zero  = zero <+> a  = a
   (a <.> b) <.> c = a <.> (b <.> c)
   a <.> one  = one <.> a  = a
   a <.> zero = zero <.> a = zero
   a <.> (b <+> c) = a <.> b <+> a <.> c
   (a <+> b) <.> c = a <.> c <+> b <.> c
-}
class Semiring a where
  zero  :: a
  (<+>) :: a -> a -> a
  one   :: a
  (<.>) :: a -> a -> a
  srsum :: [a] -> a
  srsum = foldr (<+>) zero
  srprod :: [a] -> a
  srprod = foldr (<.>) one


{- Laws:
   star a = one <+> a <.> star a
          = one <+> star a <.> a
-}
class Semiring a => StarSemiring a where
  star :: a -> a
  star a = one <+> plus a
  plus :: a -> a
  plus a = a <.> star a


{- Laws:
   a <+> a = a
   a <.> x <+> x = x  ==>  star a <.> x <+> x = x
   x <.> a <+> x = x  ==>  x <.> star a <+> x = x
-}
class StarSemiring a => KleeneAlgebra a where







