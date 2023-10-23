
c(U_EID, type, unit)         # passive,
c(U_EID, template, Tempalte) # passive,
c(T_EID, type, template)     # passive,
c(T_EID, catalog, unit)      # passive,
c(T_EID, id, Tempalte)       # passive,
c(T_EID, class, Class)       # passive
\
destroy_unit(U_EID)
<=>
  format("destroy_unit ~w ~n", [U_EID]),
  unit_on_destroy(Class, T_EID, U_EID),  
  remove_component(U_EID, type),
  remove_component(U_EID, template),
  remove_component(U_EID, position),
  remove_component(U_EID, player_no),
  destroy_e(U_EID),
  true.  

destroy_unit(U_EID) <=> true.

%% -- dispatch --

c(U_EID, abils, Abils) # passive,
c(U_EID, weapons, Weapons) # passive
\
unit_on_destroy(c_unit, T_EID, U_EID)
<=>
  format("unit_on_destroy c_unit~n"),
  remove_component(U_EID, order_queue),
  remove_component(U_EID, bounds),
  remove_component(U_EID, life),
  remove_component(U_EID, life_max),
  remove_component(U_EID, energy),
  remove_component(U_EID, energy_max),
  remove_component(U_EID, speed),
  maplist([A, AID]>>destroy_abil(A), Abils, _),
  remove_component(U_EID, abils),
  maplist([W, WID]>>destroy_weapon(W), Weapons, _),
  remove_component(U_EID, weapons),
  true.
