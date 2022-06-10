%% create_weapon
c(T_EID, type, template) # passive,
c(T_EID, catalog, weapon) # passive,
c(T_EID, id, Tempalte) # passive
\
create_weapon(Template, OwnerID, EID),
next_e(EID0) # passive
<=>
  EID=EID0,
  NextEID is EID0+1, next_e(NextEID),
  c(EID, type, weapon),
  c(EID, template, Template),
  c(EID, owner_id, OwnerID),  
  e(weapon_init, T_EID, EID).

create_weapon(Tempalte, OwnerID, EID) <=> true.

%% destroy_weapon
c(W_EID, type, weapon) # passive,
c(W_EID, template, Tempalte) # passive,
c(T_EID, type, template) # passive,
c(T_EID, catalog, weapon) # passive,
c(T_EID, id, Tempalte) # passive
\
destroy_weapon(W_EID)
<=>
  e(weapon_fini, T_EID, W_EID),
  remove_component(W_EID, type), 
  remove_component(W_EID, template),
  remove_component(W_EID, owner_id).

destroy_weapon(W_EID) <=> true.