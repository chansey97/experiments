
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
create_effect(Template, Caster, Target, EID)
<=>
  create_e(EID),  
  c(EID, type, effect),
  c(EID, template, Template),
  c(EID, caster, Caster),
  c(EID, target, Target),
  effect_on_create(Class, T_EID, EID),
  true.

create_effect(Template, Caster, Target, EID) <=> true.

%% -- dispatch --

%% c_effect
effect_on_create(c_effect, T_EID, E_EID)
<=>
  format("effect_on_create c_effect~n"),
  true.

%% c_effect_response
effect_on_create(c_effect_response, T_EID, E_EID)
<=>
  format("effect_on_create c_effect_response~n"),
  true.

%% c_effect_damage
c(T_EID, amount, Class)                      # passive,
c(E_EID, caster, Caster)                     # passive,
c(E_EID, target, target(unit, Target_EID))   # passive,
c(Target_EID, type, unit)                    # passive,
c(Target_EID, life, Life)                    # passive,
c(Target_EID, life_max, LifeMax)             # passive
\
effect_on_create(c_effect_damage, T_EID, E_EID)
<=>
  format("effect_on_create c_effect_damage~n"),
  effect_on_create(c_effect_response, T_EID, E_EID),
  %% TODO: damage settlement utils?
  Life2 is Life - Amount,
  %% TODO: Is it possible to raise an event when life change, and kill unit in the event handler?
  %% because we are in the command-based language, if a unit kill the following operation would silent.  
  set_component(Target_U_EID, life, Life2),
  (   Life2 =< 0
  ->  unit_kill(Target_EID, E_EID)
  ;   true
  ),
  %% TODO: trigger event?  
  destroy_effect(E_EID),
  true.

effect_on_create(c_effect_damage, _, _) <=> true.


%% c_effect_modify_unit
c(T_EID, life, s_effect_modify_vital(change:LifeChange, change_fraction:LifeChangeFraction)) # passive,
c(T_EID, energy, s_effect_modify_vital(change:EnergyChange, change_fraction:EnergyChangeFraction)) # passive,  
c(E_EID, caster, Caster)                         # passive,
c(E_EID, target, target(unit, Target_EID))       # passive,
c(Target_EID, type, unit)                        # passive,
c(Target_EID, life, Life)                        # passive,
c(Target_EID, life_max, LifeMax)                 # passive,
c(Target_EID, energy, Energy)                    # passive,
c(Target_EID, energy_max, EnergyMax)             # passive
\
effect_on_create(c_effect_modify_unit, T_EID, E_EID)
<=>
  format("effect_on_create c_effect_modify_unit~n"),
  effect_on_create(c_effect_response, T_EID, E_EID),
  Life2 is min(Life + LifeChange, LifeMax),
  Energy2 is min(Energy + EnergyChange, EnergyMax),
  set_component(Target_U_EID, life, Life2),
  set_component(Target_U_EID, energy, Energy2),
  (   Life2 =< 0
  ->  unit_kill(Target_EID, E_EID)
  ;   true
  ),
  destroy_effect(E_EID),
  true.

effect_on_create(c_effect_modify_unit, _, _) <=> true.


%% c_effect_launch_missile
c(T_EID, ammo_unit, AmmoUnit)                      # passive,
c(E_EID, caster, caster(_, Caster_EID))            # passive
\
effect_on_create(c_effect_launch_missile, T_EID, E_EID)
<=>
  format("effect_on_create c_effect_launch_missile~n"),
  effect_on_create(c_effect_response, T_EID, E_EID),
  %% N.B. player entity and unit entity both has player_no and pos component   
  get_component(Caster_EID, position, pos(X,Y)),
  get_component(Caster_EID, player_no, PlayerNo),  
  create_unit(AmmoUnit, X, Y, PlayerNo, Ammo_U_EID),
  c(E_EID, ammo_unit, Ammo_U_EID),
  %% N.B. in missile system, it directly control the unit's mover to move to the target and check arrive
  %% Note that it use mover directly not use issue order
  true.

effect_on_create(c_effect_launch_missile, _, _) <=> true.



%% c_effect_persistent



