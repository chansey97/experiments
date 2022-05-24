c_abil_keyboard_move_create @
c(EID, template, Template) # passive
\
c(EID, event_entity_create, c_abil_keyboard_move)
<=>
  true.

c_abil_keyboard_move_create @
c(EID, template, Template) # passive
\
c(EID, event_entity_destroy, c_abil_keyboard_move)
<=>
  true.
