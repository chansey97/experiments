forall2(Generator, Goal) :-
  findall(Goal, Generator, Goals),
  maplist(call, Goals).

is_struct(Name, Arity, Term) :-
  functor(Term, Name, Arity).
