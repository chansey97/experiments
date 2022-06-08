%% N.B. CasterID can be PlayerID or UnitID ; TargetID can be PointID or UnitID,
%% Because of ECS, no need to distinguish them via interface names like below:
%% create_effect_by_player_at_point/4,
%% create_effect_by_player_at_unit/4,
%% create_effect_by_unit_at_point/4,
%% create_effect_by_unit_at_unit/4,

create_effect @
create_effect(Template, CasterID, TargetID, EID), next_e(EID0) # passive <=>
  EID=EID0,
  NextEID is EID0+1, next_e(NextEID),
  template_field_value_get(effect, Template, class, Class),
  c(EID, type, effect),
  c(EID, class, Class),
  c(EID, template, Template),
  c(EID, caster_id, CasterID),
  c(EID, target_id, TargetID),
  c(EID, event_effect_create, Class).

destory_effect @
c(EID, type, effect) # passive,
c(EID, class, Class) # passive
\
destroy_effect(EID)
<=>
  c(EID, event_effect_destroy, Class),
  remove_component(EID, type),
  remove_component(EID, class),
  remove_component(EID, template),
  remove_component(EID, caster_id),
  remove_component(EID, target_id).