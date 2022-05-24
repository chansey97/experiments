c_abil_effect_target_create @
c(EID, template, Template) # passive
\
c(EID, event_abil_create, c_abil_effect_target)
<=>
  sub_class(c_abil_effect_target, SuperClass),
  c(EID, event_abil_create, SuperClass).

c_abil_effect_instant_destroy @
c(EID, template, Template) # passive
\
c(EID, event_abil_destroy, c_abil_effect_target)
<=>
  sub_class(c_abil_effect_target, SuperClass),
  c(EID, event_abil_destroy, SuperClass).
