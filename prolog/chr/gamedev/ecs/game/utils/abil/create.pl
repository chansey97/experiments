
c(T_EID, type, template)             # passive,
c(T_EID, catalog, abil)              # passive,
c(T_EID, id, Tempalte)               # passive,
c(T_EID, class, Class)               # passive
\
create_abil(Tempalte, OwnerID, EID)
<=>
  format("create_abil ~w ~w ~w ~n", [Tempalte, OwnerID, EID]),
  create_e(EID),
  c(EID, type, abil),
  c(EID, template, Tempalte),  
  c(EID, owner_id, OwnerID),
  abil_on_create(Class, T_EID, EID),
  true.

create_abil(Tempalte, OwnerID, EID) <=> true.

%% -- dispatch --

abil_on_create(c_abil, T_EID, A_EID)
<=>
  format("abil_on_create c_abil~n"),
  true.

abil_on_create(c_abil_move, T_EID, A_EID)
<=>
  format("abil_on_create c_abil_move~n"),
  abil_on_create(c_abil, T_EID, A_EID),
  c(A_EID, cooldown, 0).

abil_on_create(c_abil_attack, T_EID, A_EID)
<=>
  format("abil_on_create c_abil_attack~n"),
  abil_on_create(c_abil, T_EID, A_EID),  
  c(A_EID, cooldown, 0).

abil_on_create(c_abil_keyboard_move, T_EID, A_EID)
<=>
  format("abil_on_create c_abil_keyboard_move~n"),
  abil_on_create(c_abil, T_EID, A_EID).

abil_on_create(c_abil_effect, T_EID, A_EID)
<=>
  format("abil_on_create c_abil_effect~n"),
  abil_on_create(c_abil, T_EID, A_EID),  
  c(A_EID, cooldown, 0).

abil_on_create(c_abil_effect_instant, T_EID, A_EID)
<=>
  format("abil_on_create c_abil_effect_instant~n"),
  abil_on_create(c_abil_effect, T_EID, A_EID).

abil_on_create(c_abil_effect_target, T_EID, A_EID)
<=>
  format("abil_on_create c_abil_effect_target~n"),
  abil_on_create(c_abil_effect, T_EID, A_EID).

abil_on_create(c_abil_morph_create, T_EID, A_EID)
<=>
  format("abil_on_create c_abil_morph_create~n"),
  abil_on_create(c_abil, T_EID, A_EID),
  c(A_EID, cooldown, 0).  


