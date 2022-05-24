create_abil @
create_abil(Template, OwnerID, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  template_field_value_get(abil, Template, class, Class),
  c(EID, type, abil),
  c(EID, class, Class),
  c(EID, template, Template),  
  c(EID, owner_id, OwnerID),
  c(EID, event_abil_create, Class).

destory_abil @
c(EID, type, abil) # passive,
c(EID, class, Class) # passive
\
destroy_abil(EID)
<=>
  c(EID, event_abil_destroy, Class),
  remove_component(EID, type),
  remove_component(EID, class),
  remove_component(EID, template),
  remove_component(EID, owner_id).
