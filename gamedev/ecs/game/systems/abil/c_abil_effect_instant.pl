%% on create
c_abil_effect_instant:event_abil_create @
c(EID, template, Template) # passive
\
c(EID, event_abil_create, c_abil_effect_instant)
<=>
  sub_class(c_abil_effect_instant, SuperClass),
  c(EID, event_abil_create, SuperClass).

%% on destroy
c_abil_effect_instant:event_abil_destroy @
c(EID, template, Template) # passive
\
c(EID, event_abil_destroy, c_abil_effect_instant)
<=>
  sub_class(c_abil_effect_instant, SuperClass),
  c(EID, event_abil_destroy, SuperClass).

%% on check
c_abil_effect_instant:event_abil_check @
c(AID, event_abil_check, c_abil_effect_instant),
c(AID, abil_target, no_target) # passive
<=>
  sub_class(c_abil_effect_instant, SuperClass),
  c(AID, event_abil_check, SuperClass)
  |
  true.

c(AID, event_abil_check, c_abil_effect_instant)
<=>
  remove_component(AID, abil_target),
  false.

%% on execute
c_abil_effect_instant:event_abil_execute @
c(AID, template, Template) # passive,
c(AID, owner_id, UID) # passive
\  
c(AID, event_abil_execute, c_abil_effect_instant)
<=>
  sub_class(c_abil_effect_instant, SuperClass),
  c(AID, event_abil_execute, SuperClass),
  template_field_value_get(abil, Template, effects, Effs),    
  maplist({UID}/[Eff, EffID]>>create_effect(Eff, UID, UID, EffID), Effs, EffIDs).

c(AID, event_abil_execute, c_abil_effect_instant)
<=>
  true.

%% on cancel
c_abil_effect_instant:event_abil_cancel @
c(AID, template, Template) # passive,
\  
c(AID, event_abil_cancel, c_abil_effect_instant)
<=>
  sub_class(c_abil_effect_instant, SuperClass),
  c(AID, event_abil_cancel, SuperClass).

c(AID, event_abil_cancel, c_abil_effect_instant) <=> true.