
%% create_weapon
c(T_EID, type, template)             # passive,
c(T_EID, catalog, weapon)            # passive,
c(T_EID, id, Tempalte)               # passive,
c(T_EID, class, Class)               # passive
\
create_weapon(Template, OwnerID, EID),
next_e(EID0) # passive
<=>
  EID=EID0,
  NextEID is EID0+1, next_e(NextEID),
  c(EID, type, weapon),
  c(EID, template, Template),
  c(EID, owner_id, OwnerID),  
  e(weapon_init, Class, T_EID, EID).

create_weapon(Tempalte, OwnerID, EID) <=> true.



%% e(weapon_init, c_weapon_legacy, T_EID, W_EID)
%% <=>
%%   e(weapon_init, c_weapon, T_EID, A_EID),  
%%   c(W_EID, cooldown, 0),
%%   c(W_EID, time_point, 0).