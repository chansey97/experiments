
c(A_EID, type, abil) # passive,
c(A_EID, class, Class) # passive,
c(A_EID, owner_id, U_EID) # passive
\
abil_execute(A_EID, Target)
<=>
  c(U_EID, target, Target),  
  abil_on_execute(Class, A_EID),
  true.


%% c_abil
abil_on_execute(c_abil, A_EID)
<=>
  format("execute c_abil~n"),
  true.

abil_on_execute(c_abil, A_EID) <=> true.

%% c_abil_effect
c(A_EID, type, abil) #passive,
c(A_EID, template, Template) # passive,
c(A_EID, owner_id, U_EID) # passive,
c(A_EID, cooldown, Cooldown) # passive,
c(T_EID, type, template) #passive,
c(T_EID, catalog, abil) #passive,
c(T_EID, id, Template) #passive,
c(T_EID, transient, Transient) #passive,
c(T_EID, cost_energy, CostEnergy) #passive,
c(T_EID, cost_cooldown, CostCooldown) #passive,
c(U_EID, type, unit) #passive,
c(U_EID, energy, Energy) #passive
\
abil_on_execute(c_abil_effect, A_EID) 
<=>
  (   \+ Transient,
      get_component(U_EID, executing_abil, ExecutingAbil)
  ->  abil_cancel(ExecutingAbil),
      c(U_EID, executing_abil, A_EID)
  ;   true
  ), 
  Energy2 is Energy - CostEnergy,
  set_component(U_EID, energy, Energy2),
  set_component(A_EID, cooldown, CostCooldown),
  create_effect(Template, U_EID, Target)  
  .

abil_on_execute(c_abil_effect, A_EID)  <=> true.

%% c_abil_effect_instant
abil_on_execute(c_abil_effect_instant, A_EID)
<=>
  abil_on_execute(c_abil_effect, A_EID).

abil_on_execute(c_abil_effect_instant, A_EID) <=> true.

%% c_abil_effect_target
abil_on_execute(c_abil_effect_target, A_EID)
<=>
  abil_on_execute(c_abil_effect, A_EID).

abil_on_execute(c_abil_effect_target, A_EID) <=> true.


%% c_abil_morph_execute @
%% c(A_EID, template, AbilTemplate) # passive,
%% c(A_EID, owner_id, U_EID) # passive,
%% c(A_EID, cooldown, Cooldown) # passive,
%% c(U_EID, template, UnitTemplate) #passive,
%% c(U_EID, energy, Energy) #passive,
%% c(U_EID, energy_max, EnergyMax) #passive,  
%% c(U_EID, life, Life) #passive,
%% c(U_EID, life_max, LifeMax) #passive
%% \
%% c(A_EID, event_abil_execute, c_abil_morph)
%% <=>
%%   template_field_value_get(abil, AbilTemplate, cost_energy, CostEnergy),
%%   template_field_value_get(abil, AbilTemplate, cost_cooldown, CostCooldown),
%%   template_field_value_get(abil, AbilTemplate, template, MorphTargetTemplate),
%%   template_field_value_get(unit, MorphTargetTemplate, life_max, MorphTargetLifeMax),
%%   template_field_value_get(unit, MorphTargetTemplate, energy_max, MorphTargetEnergyMax), 
%%   Life2 is (Life / LifeMax)*MorphTargetLifeMax,
%%   Energy2 is (Energy - CostEnergy) / EnergyMax * MorphTargetEnergyMax,
%%   replace_unit_template(U_EID, MorphTargetTemplate),
%%   set_component(U_EID, life, Life2), 
%%   set_component(U_EID, energy, Energy2),
%%   set_component(A_EID, cooldown, CostCooldown).

%% c_abil_morph_execute_cleanup @
%% c(A_EID, event_abil_execute, c_abil_morph) <=> true.




