%% on create
c_abil_effect_create @
c(EID, template, Template) # passive
\
c(EID, event_abil_create, c_abil_effect)
<=>
  c(EID, cooldown, 0).

%% on destroy
c_abil_effect_destroy @
c(EID, template, Template) # passive
\
c(EID, event_abil_destroy, c_abil_effect)
<=>
  remove_component(EID, cooldown).

%% on check
c_abil_effect_check @
c(AID, type, abil) #passive,
c(AID, template, Template) # passive,
c(AID, owner_id, UID) # passive,
c(AID, cooldown, Cooldown) # passive,
c(UID, type, unit) #passive,
c(UID, energy, Energy) #passive
\
c(AID, event_abil_check, c_abil_effect)    
<=>
  sub_class(c_abil_effect, SuperClass),
  c(AID, event_abil_check, SuperClass),
  template_field_value_get(abil, Template, cost_energy, CostEnergy),
  Energy >= CostEnergy,
  Cooldown =:= 0
  |
  true.

c_abil_effect_check_cleanup @
c(AID, event_abil_check, c_abil_effect)  <=> false.

%% on execute
c_abil_effect_execute @
c(AID, type, abil) #passive,
c(AID, template, Template) # passive,
c(AID, owner_id, UID) # passive,
c(AID, cooldown, Cooldown) # passive,
c(UID, type, unit) #passive,
c(UID, energy, Energy) #passive
\
c(AID, event_abil_execute, c_abil_effect)
<=>
  (   \+ Transient,
      get_component(UID, executing_abil, ExecutingAbil)
  ->  abil_cancel(ExecutingAbil),
      c(UID, executing_abil, AID)
  ;   true
  ),
  template_field_value_get(abil, Template, transient, Transient),
  template_field_value_get(abil, Template, cost_energy, CostEnergy),
  template_field_value_get(abil, Template, cost_cooldown, CostCooldown),  
  Energy2 is Energy - CostEnergy,
  set_component(UID, energy, Energy2),
  set_component(AID, cooldown, CostCooldown).

c_abil_effect_execute_cleanup @
c(AID, event_abil_execute, c_abil_effect) <=> true.

%% on cancel
c_abil_effect_cancel @
c(AID, type, abil) #passive,
c(AID, owner_id, UID) # passive,
c(UID, type, unit) #passive,
\
c(UID, executing_abil, AID) #passive,
c(AID, event_abil_cancel, c_abil_effect)
<=>
  true.

c_abil_effect_cancel_cleanup @
c(AID, event_abil_cancel, c_abil_effect) <=> true.