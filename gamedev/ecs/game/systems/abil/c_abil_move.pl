
%% abil_init
e(abil_init, c_abil_move, T_EID, A_EID)
<=>
  format("c_abil_move abil_init~n"),
  e(abil_init, c_abil, T_EID, A_EID),
  c(A_EID, cooldown, 0).

%% abil_fini
e(abil_fini, c_abil_move, T_EID, A_EID)
<=>
  format("c_abil_move abil_fini~n"),  
  remove_component(A_EID, cooldown),
  e(abil_fini, c_abil, T_EID, A_EID).
