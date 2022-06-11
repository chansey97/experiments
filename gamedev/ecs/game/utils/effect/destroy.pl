
%% destroy_effect
c(E_EID, type, effect) # passive,
c(E_EID, template, Tempalte) # passive,
c(T_EID, type, template) # passive,
c(T_EID, catalog, effect) # passive,
c(T_EID, id, Tempalte) # passive
\
destroy_effect(E_EID)
<=>
  e(effect_fini, T_EID, E_EID),
  remove_component(E_EID, type),
  remove_component(E_EID, template),
  remove_component(E_EID, caster_id),
  remove_component(E_EID, target_id).

destroy_effect(E_EID) <=> true.

/**/

%% c(T_EID, class, c_effect_damage) # passive
%% \
%% e(effect_fini, T_EID, E_EID)
%% <=>
%%   true.

%% c_effect_launch_missile_destroy @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_effect_destroy, c_effect_launch_missile)
%% <=> true.

%% c_effect_modify_unit_destroy @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_effect_destroy, c_effect_modify_unit)
%% <=>
%%   true.

%% c_effect_persistent.pl