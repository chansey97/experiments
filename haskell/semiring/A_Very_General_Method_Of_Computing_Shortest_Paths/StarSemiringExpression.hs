module A_Very_General_Method_Of_Computing_Shortest_Paths.StarSemiringExpression where

import A_Very_General_Method_Of_Computing_Shortest_Paths.StarSemiring

--None is addition zero
--None is ∅
--Empty is multiplication one,
--Empty is ε

data StarSemiringExpression a
  = Var a
  | Or (StarSemiringExpression a) (StarSemiringExpression a)
  | Seq (StarSemiringExpression a) (StarSemiringExpression a)
  | Star (StarSemiringExpression a)
  | None
  | Empty

instance Show a => Show (StarSemiringExpression a) where
  showsPrec d (Var a) = showParen (d > 10) (shows a)
  showsPrec d Empty = showParen (d > 10) (showString "ε")
  showsPrec d None = showParen (d > 10) (showString "0")
  showsPrec d (Star x) = showParen (d > 9) (showsPrec 9 x . showString "*")
  showsPrec d (x `Or` y) = showParen (d > 6) showStr
   where
    showStr = showsPrec 6 x . showString "|" . showsPrec 6 y
  showsPrec d (x `Seq` y) = showParen (d > 7) showStr
   where
    showStr = showsPrec 7 x . showsPrec 7 y

instance Semiring (StarSemiringExpression a) where
  zero = None
  None <+> y = y
  x <+> None = x
  x <+> y    = x `Or` y
  one = Empty
  Empty <.> y     = y
  x     <.> Empty = x
  None  <.> _     = None
  _     <.> None  = None
  x     <.> y     = x `Seq` y

instance StarSemiring (StarSemiringExpression a) where
  star None     = Empty
  star x        = Star x