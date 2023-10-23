
%% 技能 target 类型的鉴别 和 target 的有效性验证 是基于 effect 而不是 ability
%% 比如：CEffectLaunchMissile ImpactLocation 决定目标到底是 unit 还是 point，
%% CEffectLaunchMissilede ValidatorArray 验证 target unit 的有效性

c(A_EID, type, abil)         # passive,
c(A_EID, template, Tempalte) # passive,
c(T_EID, type, template)     # passive,
c(T_EID, catalog, abil)      # passive,
c(T_EID, id, Tempalte)       # passive,
c(T_EID, class, Class)       # passive
\
abil_check(A_EID, Target)
<=>
  format("abil_check ~w ~w~n", [A_EID, Target]),    
  abil_on_check(Class, T_EID, A_EID, Target).

%% -- dispatch --

%% c_abil
abil_on_check(c_abil, T_EID, A_EID, Target)
<=>
  format("abil_on_check c_abil~n"),  
  true | true.

abil_on_check(c_abil, T_EID, A_EID, Target) <=> false.

%% c_abil_effect
c(T_EID, effect, Effect)     # passive,
c(T_EID, cost_energy, CostEnergy)     # passive,
c(A_EID, owner_id, U_EID)             # passive,
c(A_EID, cooldown, Cooldown)          # passive,
c(U_EID, energy, Energy)              # passive
\
abil_on_check(c_abil_effect, T_EID, A_EID, Target)
<=>
  format("abil_on_check c_abil_effect~n"),
  abil_on_check(c_abil, T_EID, A_EID, Target),
  %% target validate check  
  effect_check(Effect, U_EID, Target),
  Energy >= CostEnergy,
  Cooldown == 0
  |  
  true.

abil_on_check(c_abil_effect, T_EID, A_EID, Target) <=> false.

%% c_abil_effect_instant
abil_on_check(c_abil_effect_instant, T_EID, A_EID, no_target)
<=>
  format("abil_on_check c_abil_effect_instant~n"),
  abil_on_check(c_abil_effect, T_EID, A_EID, Target)
  |  
  true.

abil_on_check(c_abil_effect_instant, T_EID, A_EID, Target) <=> false.

%% c_abil_effect_target
c(T_EID, effect, EffTempalte)      # passive
\
abil_on_check(c_abil_effect_target, T_EID, A_EID, target(_,_))
<=>
  format("abil_on_check c_abil_effect_target~n"),
  abil_on_check(c_abil_effect, T_EID, A_EID, Target),
  effect_check_target(EffTempalte, Target)
  |  
  true.

abil_on_check(c_abil_effect_target, T_EID, A_EID, Target) <=> false.




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


