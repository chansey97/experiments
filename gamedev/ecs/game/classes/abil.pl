%% TODO:
%% Use Prolog record s_field?

%% TODO:
%% Better constraints? e.g. min_value, max_value?

class(id = c_abil, super = null,
      [field(name = name,
             pred = string,
             default = "")
      ]).

class(id = c_abil_move, super = c_abil,
      [field(name = cost_cooldown,
             pred = number,
             default = 0)
      ]).

class(id = c_abil_attack, super = c_abil,
      [field(name = cost_cooldown,
             pred = number,
             default = 0)
      ]).

class(id = c_abil_keyboard_move, super = c_abil,
      [field(name = left_key,
             pred = number,
             default = 37),
       field(name = up_key,
             pred = number,
             default = 38),
       field(name = right_key,
             pred = number,
             default = 39),
       field(name = down_key,
             pred = number,
             default = 40)
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

class(id = c_abil_morph, super = c_abil,
      [field(name = cost_energy,
             pred = number,
             default = 0),
       field(name = cost_cooldown,
             pred = number,
             default = 0),       
       field(name = template,
             pred = atom,
             default = null)
       ]).
