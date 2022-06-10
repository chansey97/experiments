
c(T_EID, class,           c_unit        ) # passive,
c(T_EID, bounds,          Bounds        ) # passive,
c(T_EID, life_starting,   LifeStarting  ) # passive,
c(T_EID, life_max,        LifeMax       ) # passive,
c(T_EID, energy_starting, EnergyStarting) # passive,
c(T_EID, energy_max,      EnergyMax     ) # passive,
c(T_EID, speed,           Speed         ) # passive,
c(T_EID, abils,           Abils         ) # passive,
c(T_EID, weapons,         Weapons       ) # passive
\
e(unit_init, T_EID, U_EID)
<=>
  c(U_EID, order_queue, []),  
  c(U_EID, bounds, Bounds),
  c(U_EID, life, LifeStarting),
  c(U_EID, life_max, LifeMax),
  c(U_EID, energy, EnergyStarting),
  c(U_EID, energy_max, EnergyMax),
  c(U_EID, speed, Speed),
  % abils  
  maplist({U_EID}/[A, AID]>>create_abil(A, U_EID, AID), Abils, AIDs),
  c(U_EID, abils, AIDs),
  %% weapons
  maplist({U_EID}/[W, WID]>>create_weapon(W, U_EID, WID), Weapons, WIDs),
  c(U_EID, weapons, WIDs).


c(T_EID, class, c_unit) # passive,
c(U_EID, abils, Abils) # passive,
c(U_EID, weapons, Weapons) # passive
\
e(unit_fini, T_EID, U_EID)
<=>
  remove_component(U_EID, order_queue),
  remove_component(U_EID, bounds),
  remove_component(U_EID, life),
  remove_component(U_EID, life_max),
  remove_component(U_EID, energy),
  remove_component(U_EID, energy_max),
  remove_component(U_EID, speed),
  maplist([A, AID]>>destroy_abil(A), Abils, _),
  remove_component(U_EID, abils),
  maplist([W, WID]>>destroy_weapon(W), Weapons, _),
  remove_component(U_EID, weapons).





%% %% N.B. c_unit_replace_template is only for abil_morph
%% %% Is this really needed?

%% %% TODO: How to deal with order_queue after morph?

%% %% on replace template
%% c_unit_replace_template @
%% c(EID, template, Template) # passive,
%% c(EID, bounds, Bounds) # passive,
%% c(EID, life, LifeStarting) # passive,
%% c(EID, life_max, LifeMax) # passive,
%% c(EID, energy, EnergyStarting) # passive,
%% c(EID, energy_max, EnergyMax) # passive,
%% c(EID, speed, Speed) # passive,
%% c(EID, abils, Abils) # passive,
%% c(EID, weapons, Weapons) # passive,
%% c(EID, event_unit_replace_template, c_unit, Template2)
%% <=>
%%   maplist([A, AID]>>destroy_abil(A), Abils, _),
%%   maplist([W, WID]>>destroy_weapon(W), Weapons, _),
%%   c(EID, template, Template2),
%%   template_field_value_get(unit, Template2, bounds, Bounds2),
%%   template_field_value_get(unit, Template2, life_starting, LifeStarting2),  
%%   template_field_value_get(unit, Template2, life_max, LifeMax2),
%%   template_field_value_get(unit, Template2, energy_starting, EnergyStarting2),
%%   template_field_value_get(unit, Template2, energy_max, EnergyMax2),
%%   template_field_value_get(unit, Template2, speed, Speed2),
%%   template_field_value_get(unit, Template2, abils, Abils2),
%%   template_field_value_get(unit, Template2, weapons, Weapons2),
%%   c(EID, bounds, Bounds2),
%%   c(EID, life, LifeStarting2),
%%   c(EID, life_max, LifeMax2),
%%   c(EID, energy, EnergyStarting2),
%%   c(EID, energy_max, EnergyMax2),
%%   c(EID, speed, Speed2),
%%   % abils  
%%   maplist({EID}/[A, AID]>>create_abil(A, EID, AID), Abils2, AIDs2),
%%   c(EID, abils, AIDs2),
%%   %% weapons
%%   maplist({EID}/[W, WID]>>create_weapon(W, EID, WID), Weapons2, WIDs2),
%%   c(EID, weapons, WIDs2).

%% %% remove_template_components(UID, c_unit) \ c(UID, bounds, V) # passive <=> true.
%% %% remove_template_components(UID, c_unit) \ c(UID, life, V) # passive <=> true.
%% %% remove_template_components(UID, c_unit) \ c(UID, life_max, V) # passive <=> true.
%% %% remove_template_components(UID, c_unit) \ c(UID, energy, V) # passive <=> true.
%% %% remove_template_components(UID, c_unit) \ c(UID, energy_max, V) # passive <=> true.
%% %% remove_template_components(UID, c_unit) \ c(UID, speed, V) # passive <=> true.
%% %% remove_template_components(UID, c_unit) \ c(UID, abils, V) # passive <=> true.
%% %% remove_template_components(UID, c_unit) <=> true.

%% %% on start abil

%% %% abil's workflow:
%% %% event_unit_start_abil with c_abil_morph
%% %% -> event_abil_morph_check -> event_abil_check
%% %% -> event_abil_morph_execute

%% %% event_unit_start_abil with c_abil_effect_instant
%% %% -> event_abil_effect_instant_check -> event_abil_effect_check -> event_abil_check
%% %% -> event_abil_effect_instant_execute

%% %% TODO:
%% %% If a abil requrie a target, the target_id will be a component already attached in abil entity

%% c_unit_issue_order @
%% c(UID, type, unit) # passive,
%% c(UID, abils, AIDs) # passive,
%% c(AID, type, abil) # passive,
%% c(AID, template, AbilTemplate) # passive
%% \
%% c(UID, next_order_abil, AbilTemplate) # passive,
%% c(UID, next_order_abil_target, AbilTarget) # passive,
%% c(UID, event_unit_issue_order, c_unit)
%% <=>
%%   memberchk(AID, AIDs),
%%   abil_check(AID, AbilTarget)
%%   |
%%   abil_execute(AID, AbilTarget).

%% %% c_unit_issue_order_cleanup @
%% %% c(UID, next_order_abil, AbilTemplate) # passive,
%% %% c(UID, next_order_abil_target, AbilTarget) # passive,
%% %% c(UID, event_unit_issue_order, c_unit)
%% %% <=>
%% %%   true.

