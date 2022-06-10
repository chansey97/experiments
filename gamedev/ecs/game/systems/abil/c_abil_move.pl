%% TODO: need c(A_EID, type, unit) at the rule's head?

%% abil_init
c(T_EID, class, c_abil_move) # passive
\
e(abil_init, T_EID, A_EID)
<=>
  c(A_EID, cooldown, 0).

%% abil_fini
c(T_EID, class, c_abil_move) # passive
\
e(abil_fini, T_EID, A_EID)
<=>
  remove_component(A_EID, cooldown).
