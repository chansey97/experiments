%% %% TODO: kill_unit, etc.

%% unit_replace_template @
%% c(EID, type, unit) # passive,
%% c(EID, class, Class) # passive
%% \
%% replace_unit_template(EID, Template)
%% <=>
%%   c(EID, event_unit_replace_template, Class, Template).





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
