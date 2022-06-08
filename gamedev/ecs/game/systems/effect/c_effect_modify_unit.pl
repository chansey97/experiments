%% on create
c_effect_modify_unit_create @
c(EID, template, Template) # passive
\
c(EID, event_effect_create, c_effect_modify_unit)
<=>
  c(EID, event_effect_start, c_effect_modify_unit),
  destroy_effect(EID).          % transient effect

%% on destroy
c_effect_modify_unit_destroy @
c(EID, template, Template) # passive
\
c(EID, event_effect_destroy, c_effect_modify_unit)
<=>
  true.

%% N.B.
%% CasterID and TargetID might be the same entity, so we can not depend on CHR heads.
%% ECS might only get the aspects of the current entity, it doesn't work for other entities.
%% Here distinct CasterID and TargetID must be use entailment tests.
%% 
%% BTW, if you want to get other entities' components, CHR doesn't help...
%% For example, if you want to get all the entities in some area which has specific components,
%% CHR heads doesn't heap, because CHR heads are statics.
%% You must use aux methods...

%% on start
c_effect_modify_unit_start @
c(EffID, type, effect) # passive,
c(EffID, template, Template) # passive,
c(EffID, caster_id, CasterID) # passive,
c(EffID, target_id, TargetID) # passive,
c(TargetID, type, unit) # passive,
c(TargetID, life, Life) # passive,
c(TargetID, life_max, LifeMax) # passive
\
c(EffID, event_effect_start, c_effect_modify_unit)
<=>
  template_field_value_get(effect, Template, life, s_effect_modify_vital(change:Change, change_fraction:ChangeFraction)),
  Life2 is min(Life + Change, LifeMax),
  set_component(TargetID, life, Life2).

%% %% TODO: trigger event?
%% %% https://www.swi-prolog.org/pldoc/man?section=broadcast

c_effect_modify_unit_start_cleanup @
c(EffID, event_effect_start, c_effect_modify_unit) <=>  true.


%% TODO: trigger event?
%% https://www.swi-prolog.org/pldoc/man?section=broadcast
