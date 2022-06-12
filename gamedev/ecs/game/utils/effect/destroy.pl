
%% destroy_effect
c(E_EID, type, effect) # passive,
c(E_EID, template, Tempalte) # passive,
c(T_EID, type, template) # passive,
c(T_EID, catalog, effect) # passive,
c(T_EID, id, Tempalte)       # passive,
c(T_EID, class, Class)       # passive
\
destroy_effect(E_EID)
<=>
  format("destroy_effect ~w ~n", [E_EID]),    
  effect_on_destroy(Class, T_EID, E_EID),
  remove_component(E_EID, type),
  remove_component(E_EID, template),
  remove_component(E_EID, caster_id),
  remove_component(E_EID, target_id),
  destroy_e(E_EID),  
  true.

destroy_effect(E_EID) <=> true.


%% -- dispatch --

effect_on_destroy(c_effect, T_EID, E_EID)
<=>
  format("c_effect c_abil~n"),
  true.

effect_on_destroy(c_effect_response, T_EID, E_EID)
<=>
  format("effect_on_destroy c_effect_response~n"),
  remove_component(E_EID, cooldown),
  effect_on_destroy(c_effect, T_EID, E_EID),
  true.

effect_on_destroy(c_effect_damage, T_EID, E_EID)
<=>
  format("effect_on_destroy c_effect_damage~n"),
  effect_on_destroy(c_effect_response, T_EID, E_EID),
  true.

effect_on_destroy(c_effect_modify_unit, T_EID, E_EID)
<=>
  format("effect_on_destroy c_effect_modify_unit~n"),
  effect_on_destroy(c_effect_response, T_EID, E_EID),
  true.

effect_on_destroy(c_effect_launch_missile, T_EID, E_EID)
<=>
  format("effect_on_destroy c_effect_launch_missile~n"),
  remove_component(E_EID, ammo_unit),
  effect_on_destroy(c_effect_response, T_EID, E_EID),
  true.
