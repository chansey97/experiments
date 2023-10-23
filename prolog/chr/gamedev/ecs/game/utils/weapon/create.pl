
c(T_EID, type, template)             # passive,
c(T_EID, catalog, weapon)            # passive,
c(T_EID, id, Tempalte)               # passive,
c(T_EID, class, Class)               # passive
\
create_weapon(Template, OwnerID, EID)
<=>
  format("create_weapon ~w ~w ~w ~n", [Tempalte, OwnerID, EID]),
  create_e(EID),
  c(EID, type, weapon),
  c(EID, template, Template),
  c(EID, owner_id, OwnerID),  
  weapon_on_create(Class, T_EID, EID),
  true.

create_weapon(Tempalte, OwnerID, EID) <=> true.

%% -- dispatch --

weapon_on_create(c_weapon, T_EID, W_EID)
<=>
  format("weapon_on_create c_weapon~n"),
  true.

weapon_on_create(c_weapon_legacy, T_EID, W_EID)
<=>
  format("weapon_on_create c_weapon_legacy~n"),
  c(W_EID, cooldown, 0),
  c(W_EID, time_point, 0),
  true.

