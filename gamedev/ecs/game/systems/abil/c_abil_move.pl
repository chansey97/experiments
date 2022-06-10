%% TODO: need c(A_EID, type, unit) at the rule's head?

%% TODO: c(C_EID, super, SuperClass) should be c(C_EID, super_eid, SC_EID)

%% abil_init
c(C_EID, type, class)             # passive,
c(C_EID, id, c_abil_move)         # passive,
c(C_EID, super, SuperClass)       # passive,
c(SC_EID, type, class)            # passive,
c(SC_EID, id, SuperClass)         # passive
\
e(abil_init, C_EID, T_EID, A_EID)
<=>
  format("c_abil_move abil_init~n"),
  e(abil_init, SC_EID, T_EID, EID),
  c(A_EID, cooldown, 0).

%% abil_fini
c(C_EID, type, class)             # passive,
c(C_EID, id, c_abil_move)         # passive,
c(C_EID, super, SuperClass)       # passive,
c(SC_EID, type, class)            # passive,
c(SC_EID, id, SuperClass)         # passive
\
e(abil_fini, C_EID, T_EID, A_EID)
<=>
  format("c_abil_move abil_fini~n"),  
  remove_component(A_EID, cooldown),
  e(abil_fini, SC_EID, T_EID, EID).
