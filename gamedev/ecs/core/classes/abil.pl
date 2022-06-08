
%% TODO:
%% The class and class_field here are just machine representation and not very readable.
%% May be better to have configration representation which is more readable.

%% FIXME:
%% Although it is a machine currently, it is not a good representation...
%% It seems that there is no need to have machine representation, because performance doesn't matter here.
%% When running, we mostly use template entities.

%% TODO:
%% Better constraints? e.g. min_value, max_value?

%% class(name = c_abil_effect, super = c_abil
%%      [field(name = transient,
%%             pred = atom,
%%             default = false),
%%       field(name = cost_cooldown,
%%             pred = number,
%%             default = 0),
%%       field(name = cost_energy,
%%             pred = number,
%%             default = 0),
%%       field(name = effects,
%%             pred = list,
%%             default = [])
%%      ]).

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

