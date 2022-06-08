
%% c_abil
class(c_abil, super, null).
class_field(c_abil, name, {pred:string, default:""}).

%% c_abil_effect
class(c_abil_effect, super, c_abil).
class_field(c_abil_effect, transient, {pred:atom, default:false}).
class_field(c_abil_effect, cost_energy, {pred:integer, default:0}).
class_field(c_abil_effect, cost_cooldown, {pred:integer, default:0}).
class_field(c_abil_effect, effects, {pred:is_list, default:[]}).

%% c_abil_effect_instant
class(c_abil_effect_instant, super, c_abil_effect).

%% c_abil_effect_target
class(c_abil_effect_target, super, c_abil_effect).
class_field(c_abil_effect_target, range, {pred:integer, default:0}).
