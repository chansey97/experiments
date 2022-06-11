
%% abil_execute @
%% c(AID, type, abil) # passive,
%% c(AID, class, Class) # passive
%% \
%% abil_execute(AID, AbilTarget)
%% <=>
%%   c(AID, abil_target, AbilTarget),
%%   c(AID, event_abil_execute, Class).


%% %% on execute
%% c_abil_execute @
%% c(AID, event_abil_execute, c_abil)
%% <=>
%%   true.

%% c_abil_execute @
%% c(AID, event_abil_check, c_abil) <=> true.


%% c_abil_effect_execute @
%% c(AID, type, abil) #passive,
%% c(AID, template, Template) # passive,
%% c(AID, owner_id, UID) # passive,
%% c(AID, cooldown, Cooldown) # passive,
%% c(UID, type, unit) #passive,
%% c(UID, energy, Energy) #passive
%% \
%% c(AID, event_abil_execute, c_abil_effect)
%% <=>
%%   (   \+ Transient,
%%       get_component(UID, executing_abil, ExecutingAbil)
%%   ->  abil_cancel(ExecutingAbil),
%%       c(UID, executing_abil, AID)
%%   ;   true
%%   ),
%%   template_field_value_get(abil, Template, transient, Transient),
%%   template_field_value_get(abil, Template, cost_energy, CostEnergy),
%%   template_field_value_get(abil, Template, cost_cooldown, CostCooldown),  
%%   Energy2 is Energy - CostEnergy,
%%   set_component(UID, energy, Energy2),
%%   set_component(AID, cooldown, CostCooldown).

%% c_abil_effect_execute_cleanup @
%% c(AID, event_abil_execute, c_abil_effect) <=> true.


%% c_abil_effect_instant:event_abil_execute @
%% c(AID, template, Template) # passive,
%% c(AID, owner_id, UID) # passive
%% \  
%% c(AID, event_abil_execute, c_abil_effect_instant)
%% <=>
%%   sub_class(c_abil_effect_instant, SuperClass),
%%   c(AID, event_abil_execute, SuperClass),
%%   template_field_value_get(abil, Template, effects, Effs),    
%%   maplist({UID}/[Eff, EffID]>>create_effect(Eff, UID, UID, EffID), Effs, EffIDs).

%% c(AID, event_abil_execute, c_abil_effect_instant)
%% <=>
%%   true.


%% c_abil_effect_target:event_abil_execute @
%% c(AID, template, Template) # passive,
%% c(AID, owner_id, UID) # passive
%% \  
%% c(AID, event_abil_execute, c_abil_effect_target)
%% <=>
%%   sub_class(c_abil_effect_target, SuperClass),
%%   c(AID, event_abil_execute, SuperClass),
%%   template_field_value_get(abil, Template, effects, Effs),    
%%   maplist({UID}/[Eff, EffID]>>create_effect(Eff, UID, UID, EffID), Effs, EffIDs).

%% c(AID, event_abil_execute, c_abil_effect_target)
%% <=>
%%   true.

c_abil_morph_execute @
c(AID, template, AbilTemplate) # passive,
c(AID, owner_id, UID) # passive,
c(AID, cooldown, Cooldown) # passive,
c(UID, template, UnitTemplate) #passive,
c(UID, energy, Energy) #passive,
c(UID, energy_max, EnergyMax) #passive,  
c(UID, life, Life) #passive,
c(UID, life_max, LifeMax) #passive
\
c(AID, event_abil_execute, c_abil_morph)
<=>
  template_field_value_get(abil, AbilTemplate, cost_energy, CostEnergy),
  template_field_value_get(abil, AbilTemplate, cost_cooldown, CostCooldown),
  template_field_value_get(abil, AbilTemplate, template, MorphTargetTemplate),
  template_field_value_get(unit, MorphTargetTemplate, life_max, MorphTargetLifeMax),
  template_field_value_get(unit, MorphTargetTemplate, energy_max, MorphTargetEnergyMax), 
  Life2 is (Life / LifeMax)*MorphTargetLifeMax,
  Energy2 is (Energy - CostEnergy) / EnergyMax * MorphTargetEnergyMax,
  replace_unit_template(UID, MorphTargetTemplate),
  set_component(UID, life, Life2), 
  set_component(UID, energy, Energy2),
  set_component(AID, cooldown, CostCooldown).

c_abil_morph_execute_cleanup @
c(AID, event_abil_execute, c_abil_morph) <=> true.




