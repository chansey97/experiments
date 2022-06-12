
c(W_EID, type, weapon)       # passive,
c(W_EID, template, Tempalte) # passive,
c(T_EID, type, template)     # passive,
c(T_EID, catalog, weapon)    # passive,
c(T_EID, id, Tempalte)       # passive,
c(T_EID, class, Class)       # passive
\
destroy_weapon(W_EID)
<=>
  format("destroy_weapon ~w ~n", [W_EID]),
  weapon_on_destroy(Class, T_EID, W_EID),
  remove_component(W_EID, type), 
  remove_component(W_EID, template),
  remove_component(W_EID, owner_id),
  destroy_e(W_EID),  
  true. 

destroy_weapon(W_EID) <=> true.

%% -- dispatch --

weapon_on_destroy(c_weapon, T_EID, W_EID)
<=>
  format("weapon_on_destroy c_weapon~n"),
  true.

weapon_on_destroy(c_weapon_legacy, T_EID, W_EID)
<=>
  format("weapon_on_destroy c_weapon_legacy~n"),
  remove_component(W_EID, cooldown),
  remove_component(W_EID, time_point),
  weapon_on_destroy(c_weapon, T_EID, W_EID),
  true.

