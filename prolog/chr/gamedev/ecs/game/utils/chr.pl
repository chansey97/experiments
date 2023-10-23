ps :-
  current_chr_constraint(Module:Name),
  format('constraint store contains ~w:~w~n', [Module, Name]),
  fail.
ps.

chr_listing(Spec) :-
  format('chr_listing ~w:~n', [Spec]),
  forall(find_chr_constraint(Constraint),
         (   subsumes_term(Spec, Constraint)
         ->  format('% ~w~n', [Constraint])
         ;   true
         )).
