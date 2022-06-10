
%% ECS interfaces

%% next_e(EID0) #passive \ get_next_e(EID) <=> EID = EID0.
%% get_next_e(EID) <=> false.

%% TODO:
%% c(EID, Component, Value) should not be called as component
%% It should be called entity_component relation.
%% get_components(EID, Cs), c(EID, N, V) # passive ==> one_c(c(EID, N, V)).
%% get_components(EID, Cs) <=> collect_c(Cs).
%% collect_c(Cs), one_c(C) # passive <=> Cs = [C|Cs1], collect_c(Cs1).
%% collect_c(Cs) <=> Cs=[].

set_component(EID, N, V), c(EID, N, _) # passive <=> c(EID, N, V).
set_component(EID, N, V) <=> true.

%% TODO: Assuming there is no multiple values components, but it should be taken into account.
%% e.g. abils which should be use multiple components instead of one component with a list value.
remove_component(EID, N), c(EID, N, _) # passive <=> true.
remove_component(EID, N) <=> true.

%% c(EID, N, V) # passive \ check_component(EID, N, V) <=> true.
%% check_component(EID, N, V) <=> false.

c(EID, N, V) # passive \ get_component(EID, N, V2) <=> V2=V.
get_component(EID, N, V) <=> false.


%% Debugging

%% ECS DB interfaces (assuming no variable in c/3).

entity_component(EID, Component, Value) :-
  find_chr_constraint(Constraint),
  Constraint=c(EID, Component, Value).

entity(EID) :-
  distinct(EID, entity_component(EID, Component, Value)).

%% component table?

print_entity(EID) :-
  format("> > print_entity~n"),
  forall(entity_component(EID, Component, Value), format("    ~w\n", c(EID, Component, Value))).

print_entities_when(Pred) :-
  format("> print_entities_when~n"),  
  forall((entity(EID),
          findall(c(EID, Component, Value), entity_component(EID, Component, Value), Group),
          call(Pred, EID, Group)        
         ),
         print_entity(EID)).
%% ?- print_entities_when([EID, Group]>> member(c(_, type, template), Group)).
%% ?- print_entities_when([EID, Group]>>(\+ member(c(_, type, template), Group))).

