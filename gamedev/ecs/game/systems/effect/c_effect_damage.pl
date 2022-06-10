
%% effect_init
c(T_EID, class, c_effect_damage) # passive
\
e(effect_init, T_EID, E_EID)
<=>
  %% e(effect_start, T_EID, E_EID),
  destroy_effect(EID). % damage is transient

%% effect_fini
c(T_EID, class, c_effect_damage) # passive
\
e(effect_fini, T_EID, E_EID)
<=>
  true.


%% %% effect_start

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

