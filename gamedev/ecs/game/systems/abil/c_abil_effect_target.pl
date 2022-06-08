%% on create
c_abil_effect_target:event_abil_create @
c(EID, template, Template) # passive
\
c(EID, event_abil_create, c_abil_effect_target)
<=>
  sub_class(c_abil_effect_target, SuperClass),
  c(EID, event_abil_create, SuperClass).

%% on destroy
c_abil_effect_target:event_abil_destroy @
c(EID, template, Template) # passive
\
c(EID, event_abil_destroy, c_abil_effect_target)
<=>
  sub_class(c_abil_effect_target, SuperClass),
  c(EID, event_abil_destroy, SuperClass).

%% on check
c_abil_effect_target:event_abil_check @
c(AID, event_abil_check, c_abil_effect_target),
c(AID, abil_target, target()) # passive
<=>
  sub_class(c_abil_effect_target, SuperClass),
  c(AID, event_abil_check, SuperClass)
  |
  true.


%% 这里对于 target 的 check 是基于 让 abil 的 “main effect” 来 check
%% abil 的 “main effect” 基于不同的 c_effect 可能不同，比如：c_effect_launch_missile 就是基于 impact_location 来决定的。
%% abil 自己也有一个 target filter，但并不重要

%% 但此时的 effect 还没创建，所以无法 check
%% 因此，我们要把 template 也作为 entitty 处理 which can handle event

%% So abil 系统 并不完全仅仅基于 AbilID，而应该基于 AbilID 和 AbilTempalteID 的关联
c_abil_effect_target:event_abil_check @
c(AID, event_abil_check, c_abil_effect_target),
c(AID, abil_target, target(TargetType, TargetValue)) # passive
% 这里的 target(TargetType, TargetValue) 要送到 effect 去判断
<=>
  sub_class(c_abil_effect_target, SuperClass),
  c(AID, event_abil_check, SuperClass)
  |
  true.

c(AID, event_abil_check, c_abil_effect_target)
<=>
  remove_component(AID, abil_target),
  false.

%% on execute
c_abil_effect_target:event_abil_execute @
c(AID, template, Template) # passive,
c(AID, owner_id, UID) # passive
\  
c(AID, event_abil_execute, c_abil_effect_target)
<=>
  sub_class(c_abil_effect_target, SuperClass),
  c(AID, event_abil_execute, SuperClass),
  template_field_value_get(abil, Template, effects, Effs),    
  maplist({UID}/[Eff, EffID]>>create_effect(Eff, UID, UID, EffID), Effs, EffIDs).

c(AID, event_abil_execute, c_abil_effect_target)
<=>
  true.


%% on cancel
c(AID, template, Template) # passive,
\  
c(AID, event_abil_cancel, c_abil_effect_target)
<=>
  sub_class(c_abil_effect_target, SuperClass),
  c(AID, event_abil_cancel, SuperClass).

c(AID, event_abil_cancel, c_abil_effect_target) <=> true.