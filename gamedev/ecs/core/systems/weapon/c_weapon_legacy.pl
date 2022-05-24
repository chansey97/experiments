c_weapon_legacy_create @
c(EID, template, Template) # passive
\
c(EID, event_weapon_create, c_weapon_legacy)
<=>
  %% TODO: morphing time and stages?
  c(EID, time_point, 0).

c_weapon_legacy_destroy @
c(EID, template, Template) # passive
\
c(EID, event_weapon_destroy, c_weapon_legacy)
<=>
  remove_component(EID, time_point).
