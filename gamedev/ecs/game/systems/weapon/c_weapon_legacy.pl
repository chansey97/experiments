
%% weapon_init

e(weapon_init, c_weapon_legacy, T_EID, W_EID)
<=>
  e(weapon_init, c_weapon, T_EID, A_EID),  
  c(W_EID, cooldown, 0),
  c(W_EID, time_point, 0).

%% weapon_fini
e(weapon_fini, c_weapon_legacy, T_EID, W_EID)
<=> 
  remove_component(W_EID, cooldown),
  remove_component(W_EID, time_point),
  e(weapon_fini, c_weapon, T_EID, A_EID).  