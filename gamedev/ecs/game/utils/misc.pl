forall2(Generator, Goal) :-
  findall(Goal, Generator, Goals),
  maplist(call, Goals).

is_struct(Name, Arity, Term) :-
  functor(Term, Name, Arity).

switch(X, [Val:Goal|Cases]) :-
  (   X=Val
  ->  call(Goal)
  ;   switch(X, Cases)
  ).

%% ?- switch(X, [
%%     a : writeln(case1),
%%     b : writeln(case2),
%%     c : writeln(case3)
%% ]).
%@ case1
%@ X = a.

%% ?- switch(X, [
%%     a : (writeln(case1), writeln(case1)),
%%     b : (writeln(case2), writeln(case1)),
%%     c : (writeln(case3), writeln(case1))
%% ]).
%@ case1
%@ case1
%@ X = a.
