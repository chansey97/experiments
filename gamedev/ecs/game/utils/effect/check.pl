
%% AbilTarget can be
%% target(point, Point), this is kind of location
%% target(unit, UnitID),
%% no_target

%% AbilCaster can be
%% caster(player, PlayerID)
%% caster(unit, UnitID)

%% 只有 check_effect 成功 才能 create
%% 这个类似于 先 abil_check 才能 abil_execute
%% 只是前者在模板级别，而后者在对象级别

c(T_EID, type, template)             # passive,
c(T_EID, catalog, effect)            # passive,
c(T_EID, id, Tempalte)               # passive,
c(T_EID, class, Class)               # passive
\
check_effect(Template, Caster, Target)
<=>
  effect_on_check(Class, T_EID, Caster, Target),
  true.

check_effect(Template, Caster, Target) <=> true.


%% c_effect
effect_on_check(c_effect, T_EID, Caster, Target)
<=>
  format("effect_on_check c_effect~n"),
  true | true.

effect_on_check(c_effect, T_EID, Caster, Target) <=> false.

%% c_effect_response
effect_on_check(c_effect_response, T_EID, Caster, Target)
<=>
  format("abil_on_check c_effect_response~n"),
  effect_on_check(c_effect, T_EID, Caster, Target)
  |  
  true.

effect_on_check(c_effect_response, T_EID, Caster, Target) <=> false.


%% c_effect_damage
c(Target_EID, type, unit)                    # passive
\
effect_on_check(c_effect_damage, T_EID, Caster, Target)
<=>
  format("effect_on_check c_effect_damage~n"),
  effect_on_check(c_effect_response, T_EID, Caster, Target),
  Target = target(unit, Target_EID)  
  |  
  true.

effect_on_check(c_effect_damage, _, _, _) <=> false.

%% c_effect_modify_unit
c(Target_EID, type, unit)                    # passive
\
effect_on_check(c_effect_modify_unit, T_EID, Caster, Target)
<=>
  format("effect_on_check c_effect_damage~n"),
  effect_on_check(c_effect_response, T_EID, Caster, Target),
  Target = target(unit, Target_EID)  
  |  
  true.

effect_on_check(c_effect_modify_unit, _, _, _) <=> false.


%% c_effect_launch_missile
c(T_EID, ammo_unit, AmmoUnit)                      # passive,
c(T_EID, launch_location, CasterType)              # passive,
c(T_EID, impact_location, TargetType)              # passive,
c(E_EID, caster, caster(_, Caster_EID))            # passive
\
effect_on_check(c_effect_launch_missile, T_EID, caster(CasterType, Source), target(TargetType, Target))
<=>
  format("effect_on_check c_effect_launch_missile~n"),
  effect_on_check(c_effect_response, T_EID, Caster, Target),  
  true.

effect_on_check(c_effect_launch_missile, _, _, _) <=> true.


