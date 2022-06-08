create_weapon @
create_weapon(Template, OwnerID, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  template_field_value_get(weapon, Template, class, Class),  
  c(EID, type, weapon),
  c(EID, class, Class),  
  c(EID, template, Template),
  c(EID, owner_id, OwnerID),  
  c(EID, event_weapon_create, Class).

destroy_weapon @
c(EID, type, weapon) # passive,
c(EID, class, Class) # passive
\
destroy_weapon(EID) <=>
  c(EID, event_weapon_destroy, Class),
  remove_component(EID, type),
  remove_component(EID, class),
  remove_component(EID, template),
  remove_component(EID, owner_id).
