
%% c_behavior
class(id = c_behavior, super = null,
     [field(name = name,
            pred = string,
            default = "")
     ]).

%% c_behavior_buff
class(id = c_behavior_buff, super = c_behavior,
     [field(name = duration,
            pred = number,
            default = 0),
      field(name = init_effect,
            pred = atom,
            default = null),      
      field(name = final_effect,
            pred = atom,
            default = null),
      field(name = period,
            pred = integer,
            default = 0),
      field(name = period_count,
            pred = integer,
            default = 0),
      field(name = periodic_effect,
            pred = atom,
            default = null)
     ]).
