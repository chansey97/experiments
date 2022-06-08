%% on create
c_abil_morph_create @
c(EID, template, Template) # passive
\
c(EID, event_abil_create, c_abil_morph)
<=>
  %% TODO: morphing time and stages?
  c(EID, cooldown, 0).

%% on destroy
c_abil_morph_destroy @
c(EID, template, Template) # passive
\
c(EID, event_abil_destroy, c_abil_morph)
<=>
  remove_component(EID, cooldown).

%% on check
c_abil_morph_check @
c(AID, template, Template) # passive,
c(AID, owner_id, UID) # passive,
c(AID, cooldown, Cooldown) # passive,
c(UID, energy, Energy) #passive
\
c(AID, event_abil_check, c_abil_morph)
<=>
  sub_class(c_abil_morph, SuperClass),
  c(AID, event_abil_check, SuperClass),
  template_field_value_get(abil, Template, cost_energy, CostEnergy),
  Energy >= CostEnergy,
  Cooldown =:= 0
  |
  true.

c_abil_morph_check_cleanup @
c(AID, event_abil_check, c_abil_morph) <=> false.

%% on execute
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



  
  