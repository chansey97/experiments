c_abil_attack_create @
c(EID, template, Template) # passive
\
c(EID, event_abil_create, c_abil_attack)
<=>
  c(EID, cooldown, 0).

c_abil_attack_destroy @
c(EID, template, Template) # passive
\
c(EID, event_abil_destroy, c_abil_attack)
<=>
  remove_component(EID, cooldown).
