c_unit_create @
c(EID, template, Template) # passive
\
c(EID, event_entity_create, c_unit)
<=>
  template_field_value_get(unit, Template, bounds, Bounds),
  template_field_value_get(unit, Template, life_starting, LifeStarting),  
  template_field_value_get(unit, Template, life_max, LifeMax),
  template_field_value_get(unit, Template, energy_starting, EnergyStarting),
  template_field_value_get(unit, Template, energy_max, EnergyMax),
  template_field_value_get(unit, Template, speed, Speed),
  template_field_value_get(unit, Template, abils, Abils),
  template_field_value_get(unit, Template, weapons, Weapons),
  c(EID, bounds, Bounds),
  c(EID, life, LifeStarting),
  c(EID, life_max, LifeMax),
  c(EID, energy, EnergyStarting),
  c(EID, energy_max, EnergyMax),
  c(EID, speed, Speed),
  % abils  
  maplist({EID}/[A, AID]>>create_abil(A, EID, AID), Abils, AIDs),
  c(EID, abils, AIDs),
  %% weapons
  maplist({EID}/[W, WID]>>create_weapon(W, EID, WID), Weapons, WIDs),
  c(EID, weapons, WIDs).

%% on destroy
c_unit_destroy @
c(EID, template, Template) # passive,
c(EID, abils, Abils) # passive,
c(EID, weapons, Weapons) # passive
\
c(EID, event_entity_destroy, c_unit)
<=>
  remove_component(EID, bounds),
  remove_component(EID, life),
  remove_component(EID, life_max),
  remove_component(EID, energy),
  remove_component(EID, energy_max),
  remove_component(EID, speed),
  maplist([A, AID]>>destroy_abil(A), Abils, _),
  remove_component(EID, abils),
  maplist([W, WID]>>destroy_weapon(W), Weapons, _),
  remove_component(EID, weapons).

%% N.B. c_unit_replace_template is only for abil_morph
%% Is this really needed?

%% on replace template
c_unit_replace_template @
c(EID, template, Template) # passive,
c(EID, bounds, Bounds) # passive,
c(EID, life, LifeStarting) # passive,
c(EID, life_max, LifeMax) # passive,
c(EID, energy, EnergyStarting) # passive,
c(EID, energy_max, EnergyMax) # passive,
c(EID, speed, Speed) # passive,
c(EID, abils, Abils) # passive,
c(EID, weapons, Weapons) # passive,
c(EID, event_unit_replace_template, c_unit, Template2)
<=>
  maplist([A, AID]>>destroy_abil(A), Abils, _),
  maplist([W, WID]>>destroy_weapon(W), Weapons, _),
  c(EID, template, Template2),
  template_field_value_get(unit, Template2, bounds, Bounds2),
  template_field_value_get(unit, Template2, life_starting, LifeStarting2),  
  template_field_value_get(unit, Template2, life_max, LifeMax2),
  template_field_value_get(unit, Template2, energy_starting, EnergyStarting2),
  template_field_value_get(unit, Template2, energy_max, EnergyMax2),
  template_field_value_get(unit, Template2, speed, Speed2),
  template_field_value_get(unit, Template2, abils, Abils2),
  template_field_value_get(unit, Template2, weapons, Weapons2),  
  c(EID, bounds, Bounds2),
  c(EID, life, LifeStarting2),
  c(EID, life_max, LifeMax2),
  c(EID, energy, EnergyStarting2),
  c(EID, energy_max, EnergyMax2),
  c(EID, speed, Speed2),
  % abils  
  maplist({EID}/[A, AID]>>create_abil(A, EID, AID), Abils2, AIDs2),
  c(EID, abils, AIDs2),
  %% weapons
  maplist({EID}/[W, WID]>>create_weapon(W, EID, WID), Weapons2, WIDs2),
  c(EID, weapons, WIDs2).

%% remove_template_components(UID, c_unit) \ c(UID, bounds, V) # passive <=> true.
%% remove_template_components(UID, c_unit) \ c(UID, life, V) # passive <=> true.
%% remove_template_components(UID, c_unit) \ c(UID, life_max, V) # passive <=> true.
%% remove_template_components(UID, c_unit) \ c(UID, energy, V) # passive <=> true.
%% remove_template_components(UID, c_unit) \ c(UID, energy_max, V) # passive <=> true.
%% remove_template_components(UID, c_unit) \ c(UID, speed, V) # passive <=> true.
%% remove_template_components(UID, c_unit) \ c(UID, abils, V) # passive <=> true.
%% remove_template_components(UID, c_unit) <=> true.

%% on start abil

%% abil's workflow:
%% event_unit_start_abil with c_abil_morph
%% -> event_abil_morph_check -> event_abil_check
%% -> event_abil_morph_execute

%% event_unit_start_abil with c_abil_effect_instant
%% -> event_abil_effect_instant_check -> event_abil_effect_check -> event_abil_check
%% -> event_abil_effect_instant_execute

%% TODO:
%% If a abil requrie a target, the target_id will be a component already attached in abil entity

unit_start_abil @
c(UID, abils, AIDs) # passive,
c(AID, template, Template) # passive
\
c(UID, event_unit_start_abil, c_unit, Template)
<=>
  memberchk(AID, AIDs),
  template_class_get(abil, Template, Class),
  c(AID, event_abil_check, Class)
  |
  c(AID, event_abil_execute, Class).

unit_start_abil_cleanup @
c(UID, event_unit_start_abil, c_unit, Template) <=> true.

%% TODO:
%% We need order system, which deal with target, unit group, order queue, etc ...
