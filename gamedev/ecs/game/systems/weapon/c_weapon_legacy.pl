
%% weapon_init
c(T_EID, class, c_weapon_legacy) # passive
\
e(weapon_init, T_EID, W_EID)
<=>
  c(W_EID, cooldown, 0),
  c(W_EID, time_point, 0).

%% weapon_fini
c(T_EID, class, c_weapon_legacy) # passive
\
e(weapon_fini, T_EID, W_EID)
<=> 
  remove_component(W_EID, cooldown),
  remove_component(W_EID, time_point).