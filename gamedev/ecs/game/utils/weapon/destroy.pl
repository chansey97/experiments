
%% destroy_weapon
c(W_EID, type, weapon)       # passive,
c(W_EID, template, Tempalte) # passive,
c(T_EID, type, template)     # passive,
c(T_EID, catalog, weapon)    # passive,
c(T_EID, id, Tempalte)       # passive,
c(T_EID, class, Class)       # passive
\
destroy_weapon(W_EID)
<=>
  e(weapon_fini, Class, T_EID, W_EID),
  remove_component(W_EID, type), 
  remove_component(W_EID, template),
  remove_component(W_EID, owner_id).

destroy_weapon(W_EID) <=> true.


%% e(weapon_fini, c_weapon_legacy, T_EID, W_EID)
%% <=> 
%%   remove_component(W_EID, cooldown),
%%   remove_component(W_EID, time_point),
%%   e(weapon_fini, c_weapon, T_EID, A_EID).  