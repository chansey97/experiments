%% c_abil_move_create @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_create, c_abil_move)
%% <=>
%%   c(EID, cooldown, 0).

%% c_abil_move_destroy @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_destroy, c_abil_move)
%% <=>
%%   remove_component(EID, cooldown).

c(T_EID, class, c_abil_move) # passive
\
e(abil_init, T_EID, A_EID)
<=>
  c(A_EID, cooldown, 0).

c(T_EID, class, c_abil_move) # passive
\
e(abil_fini, T_EID, A_EID)
<=>
  remove_component(A_EID, cooldown).
