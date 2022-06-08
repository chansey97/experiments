get_components(EID, Cs), c(EID, N, V) # passive ==> one_c(c(EID, N, V)).
get_components(EID, Cs) <=> collect_c(Cs).
collect_c(Cs), one_c(C) # passive <=> Cs = [C|Cs1], collect_c(Cs1).
collect_c(Cs) <=> Cs=[].

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


