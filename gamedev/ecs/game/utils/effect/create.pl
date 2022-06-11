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


/**/

%% c(T_EID, class, c_effect_damage) # passive
%% \
%% e(effect_init, T_EID, E_EID)
%% <=>
%%   %% e(effect_start, T_EID, E_EID),
%%   destroy_effect(EID). % damage is transient

%% c_effect_launch_missile_create @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_effect_create, c_effect_launch_missile)
%% <=>
%%   c(EID, event_effect_start, c_effect_launch_missile).

%% c_effect_modify_unit_create @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_effect_create, c_effect_modify_unit)
%% <=>
%%   c(EID, event_effect_start, c_effect_modify_unit),
%%   destroy_effect(EID).          % transient effect

%% c_effect_persistent
