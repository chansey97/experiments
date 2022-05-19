
/* Systems */

input_system @ update(input, FID), c(_, player_control, UID) #passive ==>
  current_input(IO),
  read_string(IO, 2, S),
  format("update(input, FID=~w) ", [FID]),
  (   S="a\n"
      %% TODO: c/5 can be used for trigger
  ->  c(UID, event_c_unit_start_abil, morph_bear) % assuming morph is a instant ability, so no cast system update needed
  ;   true   
  ).
input_system @ update(input, FID) <=> true.


%% abil execute workflow
%% event_c_unit_start_abil -> event_c_abil_check -> event_c_abil_morph_check -> -> event_c_abil_morph_execute

%% TODO:
%% If a abil requrie a target, the target will be a component of abil entity

%% c_unit_start_abil
event_c_unit_start_abil @
  c(UID, event_c_unit_start_abil, Template),
  c(UID, abils, AIDs) # passive,
  c(AID, template, Template) # passive
  ==>
    memberchk(AID, AIDs)
    |  
    c(AID, event_c_abil_check).

event_c_unit_start_abil @ c(_, event_c_unit_start_abil, _) <=> true.

%% c_abil
event_c_abil_check @
  c(AID, event_c_abil_check),
  c(AID, template, Template) # passive,
  c(AID, owner_id, UID) # passive
  ==>
    true % alway true, because c_abil no limit currently
    |
    c(AID, event_c_abil_morph_check).

event_c_abil_check @ c(_, event_c_abil_check) <=> true.

%% c_abil_morph
event_c_abil_morph_check @
  c(AID, event_c_abil_morph_check),
  c(AID, template, Template) # passive,
  c(AID, owner_id, UID) # passive,
  c(AID, cooldown, Cooldown) # passive,
  c(UID, energy, Energy) #passive
  ==>
    template_field_value_get(Template, cost_energy, CostEnergy),
    Energy >= CostEnergy,
    Cooldown =:= 0
    |
    c(AID, event_c_abil_morph_execute).

event_c_abil_morph_check @ c(_, event_c_abil_morph_check) <=> true.

event_c_abil_morph_execute @
  c(AID, template, AbilTemplate) # passive,
  c(AID, owner_id, UID) # passive,
  c(AID, cooldown, Cooldown) # passive,
  c(UID, template, UnitTemplate) #passive,
  c(UID, energy, Energy) #passive,
  c(UID, energy_max, EnergyMax) #passive,  
  c(UID, life, Life) #passive,
  c(UID, life_max, LifeMax) #passive
  \
  c(AID, event_c_abil_morph_execute)
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


%% movement_system @ update(move, FID), c(EID, velocity, V) #passive \ c(EID, position, X-Y) #passive <=>
%%   random(-1.0,1.0,Rand),
%%   X2 is X+Rand*V,
%%   Y2 is Y+Rand*V,
%%   c(EID, position, X2-Y2).
%% movement_system @ update(move, FID) <=> true.

%% render_system @ update(render, FID), c(EID, position, X-Y) #passive, c(EID, sprite, PNG) #passive ==>
%%   format("render frame:~w, eid:~w, ~w at (~w, ~w) ~n", [FID,EID,PNG,X,Y]).
%% movement_system @ update(render, FID) <=> true.


