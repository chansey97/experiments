
%% %% N.B.
%% %% CasterID and TargetID might be the same entity, so we can not depend on CHR heads.
%% %% ECS might only get the aspects of the current entity, it doesn't work for other entities.
%% %% Here distinct CasterID and TargetID must be use entailment tests.
%% %% 
%% %% BTW, if you want to get other entities' components, CHR doesn't help...
%% %% For example, if you want to get all the entities in some area which has specific components,
%% %% CHR heads doesn't heap, because CHR heads are statics.
%% %% You must use aux methods...

%% c_effect_damage_start @
%% c(EffID, template, Template) # passive,
%% c(EffID, caster_id, CasterID) # passive,
%% c(EffID, target_id, TargetID) # passive,
%% %% c(CasterID, type, player) # passive,
%% c(TargetID, type, unit) # passive,
%% c(TargetID, life, Life) # passive
%% \
%% c(EffID, event_effect_start, c_effect_damage)
%% <=>
%%   template_field_value_get(effect, Template, amount, Amount),
%%   Life2 is Life - Amount,  
%%   set_component(TargetID, life, Life2).


%% %% TODO: trigger event?
%% %% https://www.swi-prolog.org/pldoc/man?section=broadcast

%% c_effect_damage_start_cleanup @
%% c(EffID, event_effect_start, c_effect_damage) <=> true.



%% N.B.
%% CasterID and TargetID might be the same entity, so we can not depend on CHR heads.
%% ECS might only get the aspects of the current entity, it doesn't work for other entities.
%% Here distinct CasterID and TargetID must be use entailment tests.
%% 
%% BTW, if you want to get other entities' components, CHR doesn't help...
%% For example, if you want to get all the entities in some area which has specific components,
%% CHR heads doesn't heap, because CHR heads are statics.
%% You must use aux methods...

%% %% on start
%% c_effect_launch_missile_start@
%% c(EffID, template, Template) # passive,
%% c(EffID, caster_id, CasterID) # passive,
%% c(EffID, target_id, TargetID) # passive
%% %% c(CasterID, type, unit) # passive,
%% %% c(TargetID, type, point) # passive
%% \
%% c(EffID, event_effect_start, c_effect_launch_missile)
%% <=>
%%   format("c_effect_launch_missile_start damge from unit to point ~n")
%%   %% create ammo_unit
%%   .

%% c_effect_launch_missile_start@
%% c(EffID, template, Template) # passive,
%% c(EffID, caster_id, CasterID) # passive,
%% c(EffID, target_id, TargetID) # passive
%% %% c(CasterID, type, unit) # passive,
%% %% c(TargetID, type, unit) # passive
%% \
%% c(EffID, event_effect_start, c_effect_launch_missile)
%% <=>
%%   format("c_effect_launch_missile_start damge from unit to unit ~n")
%%   %% create ammo_unit  
%%   .

%% %% on update
%% %% when touch the target, boom, create c_effect_damage



%% %% N.B.
%% %% CasterID and TargetID might be the same entity, so we can not depend on CHR heads.
%% %% ECS might only get the aspects of the current entity, it doesn't work for other entities.
%% %% Here distinct CasterID and TargetID must be use entailment tests.
%% %% 
%% %% BTW, if you want to get other entities' components, CHR doesn't help...
%% %% For example, if you want to get all the entities in some area which has specific components,
%% %% CHR heads doesn't heap, because CHR heads are statics.
%% %% You must use aux methods...

%% %% on start
%% c_effect_modify_unit_start @
%% c(EffID, type, effect) # passive,
%% c(EffID, template, Template) # passive,
%% c(EffID, caster_id, CasterID) # passive,
%% c(EffID, target_id, TargetID) # passive,
%% c(TargetID, type, unit) # passive,
%% c(TargetID, life, Life) # passive,
%% c(TargetID, life_max, LifeMax) # passive
%% \
%% c(EffID, event_effect_start, c_effect_modify_unit)
%% <=>
%%   template_field_value_get(effect, Template, life, s_effect_modify_vital(change:Change, change_fraction:ChangeFraction)),
%%   Life2 is min(Life + Change, LifeMax),
%%   set_component(TargetID, life, Life2).

%% %% %% TODO: trigger event?
%% %% %% https://www.swi-prolog.org/pldoc/man?section=broadcast

%% c_effect_modify_unit_start_cleanup @
%% c(EffID, event_effect_start, c_effect_modify_unit) <=>  true.


%% %% TODO: trigger event?
%% %% https://www.swi-prolog.org/pldoc/man?section=broadcast
