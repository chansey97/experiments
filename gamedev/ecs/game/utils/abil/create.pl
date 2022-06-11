
%% create_abil
c(T_EID, type, template)             # passive,
c(T_EID, catalog, abil)              # passive,
c(T_EID, id, Tempalte)               # passive,
c(T_EID, class, Class)               # passive
\
create_abil(Tempalte, OwnerID, EID)           ,
next_e(EID0)                         # passive
<=>
  format("create_abil ~w ~w ~w ~n", [Tempalte, OwnerID, EID]),  
  EID=EID0,
  NextEID is EID0+1, next_e(NextEID),   
  c(EID, type, abil),
  c(EID, template, Tempalte),  
  c(EID, owner_id, OwnerID),
  %% abil_init(Class, T_EID, EID),
  e(abil_init, Class, T_EID, A_EID),
  true.

create_abil(Tempalte, OwnerID, EID) <=> true.

/*** polymorphic dispatch ***/

e(abil_init, c_abil, T_EID, A_EID)
<=>
  format("c_abil abil_init~n"),
  true.

e(abil_init, c_abil_move, T_EID, A_EID)
<=>
  format("c_abil_move abil_init~n"),
  e(abil_init, c_abil, T_EID, A_EID),
  c(A_EID, cooldown, 0).

%% c_abil_attack
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_create, c_abil_attack)
%% <=>
%%   c(EID, cooldown, 0).

%% c_abil_keyboard_move
%% c_abil_keyboard_move_create @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_create, c_abil_keyboard_move)
%% <=>
%%   true.

%% c_abil_effect
%% c_abil_effect_create @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_create, c_abil_effect)
%% <=>
%%   c(EID, cooldown, 0).

%% c_abil_effect_instant
%% c_abil_effect_instant:event_abil_create @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_create, c_abil_effect_instant)
%% <=>
%%   sub_class(c_abil_effect_instant, SuperClass),
%%   c(EID, event_abil_create, SuperClass).


%% c_abil_effect_target
%% c_abil_effect_target:event_abil_create @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_create, c_abil_effect_target)
%% <=>
%%   sub_class(c_abil_effect_target, SuperClass),
%%   c(EID, event_abil_create, SuperClass).

%% c_abil_morph_create @
%% c(EID, template, Template) # passive
%% \
%% c(EID, event_abil_create, c_abil_morph)
%% <=>
%%   %% TODO: morphing time and stages?
%%   c(EID, cooldown, 0).

