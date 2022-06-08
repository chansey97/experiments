
%% TODO:
%% Better constraints? e.g. min_value, max_value?

class(id = c_abil, super = null,
      [field(name = name,
             pred = string,
             default = "")
      ]).

class(id = c_abil_effect, super = c_abil,
      [field(name = transient,
             pred = atom,
             default = false),
       field(name = cost_energy,
             pred = number,
             default = 0),      
       field(name = cost_cooldown,
             pred = number,
             default = 0),
       field(name = effects,
             pred = is_list,
             default = [])
      ]).

class(id = c_abil_effect_instant, super = c_abil_effect,
      []).

class(id = c_abil_effect_target, super = c_abil_effect,
      [field(name = range,
             pred = number,
             default = 0)]).
