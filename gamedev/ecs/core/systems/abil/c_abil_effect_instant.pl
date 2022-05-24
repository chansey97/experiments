%% on create
c_abil_effect_instant_create @
c(EID, template, Template) # passive
\
c(EID, event_abil_create, c_abil_effect_instant)
<=>
  sub_class(c_abil_effect_instant, SuperClass),
  c(EID, event_abil_create, SuperClass).

%% on destroy
c_abil_effect_instant_destroy @
c(EID, template, Template) # passive
\
c(EID, event_abil_destroy, c_abil_effect_instant)
<=>
  sub_class(c_abil_effect_instant, SuperClass),
  c(EID, event_abil_destroy, SuperClass).

%% on check
c_abil_effect_instant_check @
  c(AID, event_abil_check, c_abil_effect_instant)
  <=>
    sub_class(c_abil_effect_instant, SuperClass),
    c(AID, event_abil_check, SuperClass)
    |
    true.

c_abil_effect_instant_check_cleanup @
c(AID, event_abil_check, c_abil_effect_instant) <=> false.

%% on execute
c_abil_effect_instant_execute @
  c(AID, template, Template) # passive,
  c(AID, owner_id, UID) # passive
  \  
  c(AID, event_abil_execute, c_abil_effect_instant)
  <=>
    template_field_value_get(abil, Template, effects, Effs),    
    maplist({UID}/[Eff, EffID]>>create_effect(Eff, UID, UID, EffID), Effs, EffIDs),
    sub_class(c_abil_effect_instant, SuperClass),
    c(AID, event_abil_execute, SuperClass).

c_abil_effect_instant_execute_cleanup@
c(AID, event_abil_execute, c_abil_effect_instant) <=> true.
