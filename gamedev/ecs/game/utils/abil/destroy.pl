
c(A_EID, type, abil)         # passive,
c(A_EID, template, Tempalte) # passive,
c(T_EID, type, template)     # passive,
c(T_EID, catalog, abil)      # passive,
c(T_EID, id, Tempalte)       # passive,
c(T_EID, class, Class)       # passive
\
destroy_abil(A_EID)
<=>
  format("destroy_abil ~w ~n", [A_EID]),    
  abil_on_destroy(Class, T_EID, A_EID),
  remove_component(A_EID, type),
  remove_component(A_EID, template),
  remove_component(A_EID, owner_id),
  destroy_e(A_EID),  
  true.

destroy_abil(A_EID) <=> true.

%% -- dispatch --

abil_on_destroy(c_abil, T_EID, A_EID)
<=>
  format("abil_on_destroy c_abil~n"),
  true.

abil_on_destroy(c_abil_move, T_EID, A_EID)
<=>
  format("abil_on_destroy c_abil_move~n"),
  remove_component(A_EID, cooldown),
  abil_on_destroy(c_abil, T_EID, A_EID),
  true.

abil_on_destroy(c_abil_attack, T_EID, A_EID)
<=>
  format("abil_on_destroy c_abil_attack~n"),
  remove_component(A_EID, cooldown),
  abil_on_destroy(c_abil, T_EID, A_EID),
  true.

abil_on_destroy(c_abil_keyboard_move, T_EID, A_EID)
<=>
  format("abil_on_destroy c_abil_keyboard_move~n"),
  abil_on_destroy(c_abil, T_EID, A_EID),
  true.

abil_on_destroy(c_abil_effect, T_EID, A_EID)
<=>
  format("abil_on_destroy c_abil_effect~n"),
  remove_component(A_EID, cooldown),
  abil_on_destroy(c_abil, T_EID, A_EID),
  true.

abil_on_destroy(c_abil_effect_instant, T_EID, A_EID)
<=>
  format("abil_on_destroy c_abil_effect_instant~n"),
  abil_on_destroy(c_abil_effect, T_EID, A_EID),
  true.

abil_on_destroy(c_abil_effect_target, T_EID, A_EID)
<=>
  format("abil_on_destroy c_abil_effect_target~n"),
  abil_on_destroy(c_abil_effect, T_EID, A_EID),
  true.

abil_on_destroy(c_abil_morph, T_EID, A_EID)
<=>
  format("abil_on_destroy c_abil_morph~n"),
  remove_component(A_EID, cooldown),
  abil_on_destroy(c_abil, T_EID, A_EID),
  true.



