
%% 技能 target 类型的鉴别 和 target 的有效性验证 是基于 effect 而不是 ability
%% 比如：CEffectLaunchMissile ImpactLocation 决定目标到底是 unit 还是 point，
%% CEffectLaunchMissilede ValidatorArray 验证 target unit 的有效性


%% abil_check @
%% c(AID, type, abil) # passive,
%% c(AID, class, Class) # passive
%% \
%% abil_check(AID, AbilTarget)
%% <=>
%%   c(AID, abil_target, AbilTarget),
%%   c(AID, event_abil_check, Class).

%% %% on check
%% c_abil_check @
%% c(AID, event_abil_check, c_abil)
%% <=>  
%%   true.

%% c_abil_check @
%% c(AID, event_abil_check, c_abil) <=> false.


%% c_abil_effect_check @
%% c(AID, type, abil) #passive,
%% c(AID, template, Template) # passive,
%% c(AID, owner_id, UID) # passive,
%% c(AID, cooldown, Cooldown) # passive,
%% c(UID, type, unit) #passive,
%% c(UID, energy, Energy) #passive
%% \
%% c(AID, event_abil_check, c_abil_effect)    
%% <=>
%%   sub_class(c_abil_effect, SuperClass),
%%   c(AID, event_abil_check, SuperClass),
%%   template_field_value_get(abil, Template, cost_energy, CostEnergy),
%%   Energy >= CostEnergy,
%%   Cooldown =:= 0
%%   |
%%   true.

%% c_abil_effect_check_cleanup @
%% c(AID, event_abil_check, c_abil_effect)  <=> false.


%% c_abil_effect_instant:event_abil_check @
%% c(AID, event_abil_check, c_abil_effect_instant),
%% c(AID, abil_target, no_target) # passive
%% <=>
%%   sub_class(c_abil_effect_instant, SuperClass),
%%   c(AID, event_abil_check, SuperClass)
%%   |
%%   true.

%% c(AID, event_abil_check, c_abil_effect_instant)
%% <=>
%%   remove_component(AID, abil_target),
%%   false.

%% c_abil_effect_target:event_abil_check @
%% c(AID, event_abil_check, c_abil_effect_target),
%% c(AID, abil_target, target()) # passive
%% <=>
%%   sub_class(c_abil_effect_target, SuperClass),
%%   c(AID, event_abil_check, SuperClass)
%%   |
%%   true.


%% %% 这里对于 target 的 check 是基于 让 abil 的 “main effect” 来 check
%% %% abil 的 “main effect” 基于不同的 c_effect 可能不同，比如：c_effect_launch_missile 就是基于 impact_location 来决定的。
%% %% abil 自己也有一个 target filter，但并不重要

%% %% 但此时的 effect 还没创建，所以无法 check
%% %% 因此，我们要把 template 也作为 entitty 处理 which can handle event

%% %% So abil 系统 并不完全仅仅基于 AbilID，而应该基于 AbilID 和 AbilTempalteID 的关联
%% c_abil_effect_target:event_abil_check @
%% c(AID, event_abil_check, c_abil_effect_target),
%% c(AID, abil_target, target(TargetType, TargetValue)) # passive
%% % 这里的 target(TargetType, TargetValue) 要送到 effect 去判断
%% <=>
%%   sub_class(c_abil_effect_target, SuperClass),
%%   c(AID, event_abil_check, SuperClass)
%%   |
%%   true.

%% c(AID, event_abil_check, c_abil_effect_target)
%% <=>
%%   remove_component(AID, abil_target),
%%   false.

%% c_abil_morph_check @
%% c(AID, template, Template) # passive,
%% c(AID, owner_id, UID) # passive,
%% c(AID, cooldown, Cooldown) # passive,
%% c(UID, energy, Energy) #passive
%% \
%% c(AID, event_abil_check, c_abil_morph)
%% <=>
%%   sub_class(c_abil_morph, SuperClass),
%%   c(AID, event_abil_check, SuperClass),
%%   template_field_value_get(abil, Template, cost_energy, CostEnergy),
%%   Energy >= CostEnergy,
%%   Cooldown =:= 0
%%   |
%%   true.

%% c_abil_morph_check_cleanup @
%% c(AID, event_abil_check, c_abil_morph) <=> false.


