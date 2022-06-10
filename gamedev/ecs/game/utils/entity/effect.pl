%% N.B. CasterID can be PlayerID or UnitID ; TargetID can be PointID or UnitID,
%% Because of ECS, no need to distinguish them via interface names like below:
%% create_effect_by_player_at_point/4,
%% create_effect_by_player_at_unit/4,
%% create_effect_by_unit_at_point/4,
%% create_effect_by_unit_at_unit/4,

%% TODO: PointID is not good, because have to gc.
%% So still distinguish point and unitID

%% create_effect
c(T_EID, type, template) # passive,
c(T_EID, catalog, effect) # passive,
c(T_EID, id, Tempalte) # passive
\
create_effect(Template, CasterID, TargetID, EID),
next_e(EID0) # passive
<=>
  EID=EID0,
  NextEID is EID0+1, next_e(NextEID),
  c(EID, type, effect),
  c(EID, template, Template),
  c(EID, caster_id, CasterID),
  c(EID, target_id, TargetID),
  e(effect_init, T_EID, EID).

create_effect(Template, CasterID, TargetID, EID) <=> true.

%% destroy_effect
c(E_EID, type, effect) # passive,
c(E_EID, template, Tempalte) # passive,
c(T_EID, type, template) # passive,
c(T_EID, catalog, effect) # passive,
c(T_EID, id, Tempalte) # passive
\
destroy_effect(E_EID)
<=>
  e(effect_fini, T_EID, E_EID),
  remove_component(E_EID, type),
  remove_component(E_EID, template),
  remove_component(E_EID, caster_id),
  remove_component(E_EID, target_id).

destroy_effect(E_EID) <=> true.