
/* Systems */

input_system @ update(input, FID), c(_, player_control, UID) #passive ==>
  current_input(IO),
  read_string(IO, 2, S),
  format("update(input, FID=~w) ", [FID]),
  (   S="a\n"
      %% TODO: c/5 can be used for trigger
  ->  c(UID, event_unit_start_abil, morph_bear) % assuming morph is a instant ability, so no cast system update needed
  ;   true   
  ).
input_system @ update(input, FID) <=> true.


%% Abil execute workflow:

%% event_unit_start_abil
%% -> event_abil_check
%% -> event_abil_morph_check
%% -> event_abil_morph_execute

%% event_unit_start_abil
%% -> event_abil_check
%% -> event_abil_effect_check
%% -> event_abil_effect_instant_check
%% -> event_abil_effect_instant_execute


%% TODO:
%% If a abil requrie a target, the target will be a component of abil entity

%% event_unit_start_abil
event_unit_start_abil @
  c(UID, abils, AIDs) # passive,
  c(AID, template, Template) # passive
  \
  c(UID, event_unit_start_abil, Template)  
  <=>
    memberchk(AID, AIDs),
    template_class_get(Template, Class),
    c(AID, event_abil_check, Class)
    |
    c(AID, event_abil_execute, Class).

event_unit_start_abil @ c(AID, event_unit_start_abil, Class) <=> true.

%% c_abil
event_abil_check @
  c(AID, event_abil_check, c_abil)
  <=>  
    true.

event_abil_check @ c(AID, event_abil_check, c_abil) <=> false.

event_abil_execute @
  c(AID, event_abil_execute, c_abil)
  <=>
    true.

event_abil_execute @ c(AID, event_abil_check, c_abil) <=> true.

%% c_abil_morph
event_abil_check @
  c(AID, template, Template) # passive,
  c(AID, owner_id, UID) # passive,
  c(AID, cooldown, Cooldown) # passive,
  c(UID, energy, Energy) #passive
  \
  c(AID, event_abil_check, c_abil_morph)  
  <=>
    sub_class(c_abil_morph, SuperClass),
    c(AID, event_abil_check, SuperClass),
    template_field_value_get(Template, cost_energy, CostEnergy),
    Energy >= CostEnergy,
    Cooldown =:= 0
    |
    true.

event_abil_check @ c(AID, event_abil_check, c_abil_morph) <=> false.

event_abil_execute @
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
    template_field_value_get(UnitTemplate, class, UnitClass),
    template_field_value_get(AbilTemplate, cost_energy, CostEnergy),
    template_field_value_get(AbilTemplate, cost_cooldown, CostCooldown),
    template_field_value_get(AbilTemplate, template, MorphTargetTemplate),
    template_field_value_get(MorphTargetTemplate, class, MorphTargetClass),
    template_field_value_get(MorphTargetTemplate, life_max, MorphTargetLifeMax),
    template_field_value_get(MorphTargetTemplate, energy_max, MorphTargetEnergyMax), 
    Life2 is (Life / LifeMax)*MorphTargetLifeMax,
    Energy2 is (Energy - CostEnergy) / EnergyMax * MorphTargetEnergyMax,
    remove_template_components(UID, UnitClass),
    add_template_components(UID, MorphTargetClass, MorphTargetTemplate),
    set_component(UID, life, Life2), 
    set_component(UID, energy, Energy2),
    set_component(AID, cooldown, CostCooldown).

event_abil_execute @ c(AID, event_abil_execute, c_abil_morph) <=> true.

%% c_abil_effect
event_abil_check @
  c(AID, template, Template) # passive,
  c(AID, owner_id, UID) # passive,
  c(AID, cooldown, Cooldown) # passive,
  c(UID, energy, Energy) #passive
  \
  c(AID, event_abil_check, c_abil_effect)    
  <=>
    sub_class(c_abil_effect, SuperClass),
    c(AID, event_abil_check, SuperClass),
    template_field_value_get(Template, cost_energy, CostEnergy),
    Energy >= CostEnergy,
    Cooldown =:= 0
    |
    true.

event_abil_check @ c(AID, event_abil_check, c_abil_effect)  <=> false.

event_abil_execute @
  c(AID, template, AbilTemplate) # passive,
  c(AID, owner_id, UID) # passive,
  c(AID, cooldown, Cooldown) # passive,
  c(UID, energy, Energy) #passive
  \
  c(AID, event_abil_execute, c_abil_effect)
  <=>
    template_field_value_get(AbilTemplate, cost_energy, CostEnergy),
    template_field_value_get(AbilTemplate, cost_cooldown, CostCooldown),    
    Energy2 is Energy - CostEnergy,
    set_component(UID, energy, Energy2),
    set_component(AID, cooldown, CostCooldown).

event_abil_execute @ c(AID, event_abil_execute, c_abil_effect) <=> true.

%% c_abil_effect_instant
event_abil_check @
  c(AID, event_abil_check, c_abil_effect_instant)
  <=>
    sub_class(c_abil_effect, SuperClass),
    c(AID, event_abil_check, SuperClass)
    |
    true.

event_abil_check @ c(_, event_abil_check, c_abil_effect_instant) <=> false.

event_abil_execute @
  c(AID, template, Template) # passive,
  c(AID, owner_id, UID) # passive
  \  
  c(AID, event_abil_execute, c_abil_effect_instant)
  <=>
    %% create effect    
    c(AID, event_abil_execute, c_abil_effect).

event_abil_execute @ c(AID, event_abil_execute, c_abil_effect_instant) <=> true.



%% movement_system @ update(move, FID), c(EID, velocity, V) #passive \ c(EID, position, X-Y) #passive <=>
%%   random(-1.0,1.0,Rand),
%%   X2 is X+Rand*V,
%%   Y2 is Y+Rand*V,
%%   c(EID, position, X2-Y2).
%% movement_system @ update(move, FID) <=> true.

%% render_system @ update(render, FID), c(EID, position, X-Y) #passive, c(EID, sprite, PNG) #passive ==>
%%   format("render frame:~w, eid:~w, ~w at (~w, ~w) ~n", [FID,EID,PNG,X,Y]).
%% movement_system @ update(render, FID) <=> true.


