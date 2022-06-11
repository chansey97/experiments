
%% destroy_abil
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
  e(abil_fini, Class, T_EID, A_EID),
  remove_component(A_EID, type),
  remove_component(A_EID, template),
  remove_component(A_EID, owner_id),  
  true.

destroy_abil(A_EID) <=> true.


/*** polymorphic dispatch ***/

%% e(abil_fini, c_abil, T_EID, A_EID)
%% <=>
%%   format("c_abil abil_fini~n"),  
%%   true.

%% e(abil_fini, c_abil_move, T_EID, A_EID)
%% <=>
%%   format("c_abil_move abil_fini~n"),  
%%   remove_component(A_EID, cooldown),
%%   e(abil_fini, c_abil, T_EID, A_EID).

%% c_abil_attack_destroy @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_destroy, c_abil_attack)
%% <=>
%%   remove_component(EID, cooldown).

%% c_abil_keyboard_move_destroy @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_destroy, c_abil_keyboard_move)
%% <=>
%%   true.

%% c_abil_effect_destroy @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_destroy, c_abil_effect)
%% <=>
%%   remove_component(EID, cooldown).

%% c_abil_effect_instant:event_abil_destroy @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_destroy, c_abil_effect_instant)
%% <=>
%%   sub_class(c_abil_effect_instant, SuperClass),
%%   c(EID, event_abil_destroy, SuperClass).

%% c_abil_effect_target:event_abil_destroy @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_destroy, c_abil_effect_target)
%% <=>
%%   sub_class(c_abil_effect_target, SuperClass),
%%   c(EID, event_abil_destroy, SuperClass).

%% c_abil_morph_destroy @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_destroy, c_abil_morph)
%% <=>
%%   remove_component(EID, cooldown).



