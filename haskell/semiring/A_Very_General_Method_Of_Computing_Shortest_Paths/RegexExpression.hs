module A_Very_General_Method_Of_Computing_Shortest_Paths.RegexExpression where

import A_Very_General_Method_Of_Computing_Shortest_Paths.StarSemiring
import A_Very_General_Method_Of_Computing_Shortest_Paths.StarSemiringExpression

newtype RE a = RE (StarSemiringExpression a)

re :: a -> RE a
re = RE . Var

-- An algorithm for deciding if two regular expressions are equal is beyond the scope of this blog post.
-- The problem is PSPACE complete, so it can be quite slow. We will not need to compare regular expressions in this post so we can skip this implementation for now

todo = error "TODO"

instance Eq a => Eq (RE a) where
  (RE x) == (RE y) = (todo)

instance Semiring (RE a) where
  zero = RE None
  RE None <+> y = y
  x <+> RE None = x
  RE Empty <+> RE Empty    = RE Empty
  RE Empty <+> RE (Star y) = RE (Star y)
  RE (Star x) <+> RE Empty = RE (Star x)
  RE x <+> RE y            = RE (x `Or` y)
  one = RE Empty
  RE Empty <.> y = y
  x <.> RE Empty = x
  RE None <.> _  = RE None
  _ <.> RE None  = RE None
  RE x <.> RE y  = RE (x `Seq` y)

instance StarSemiring (RE a) where
  star (RE None)     = RE Empty
  star (RE Empty)    = RE Empty
  star (RE (Star x)) = star (RE x)
  star (RE x)        = RE (Star x)

instance KleeneAlgebra (RE a) where

instance Show a => Show (RE a) where
  showsPrec d (RE x) = showsPrec d x

