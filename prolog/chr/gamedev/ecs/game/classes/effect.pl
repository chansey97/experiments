
%% TODO:
%% Is it necessary to rename field -> s_field, and use Prolog record instead?

%% TODO:
%% s_effect_modify_vital(change:0, change_fraction:0)) need change and change_fraction fields?
%% Using = instead of :?

class(id = c_effect, super = null,
      [field(name = name,
             pred = string,
             default = "")
      ]).

class(id = c_effect_response, super = c_effect,
      []).

class(id = c_effect_set, super = c_effect,
      [field(name = effects,
             pred = is_list,
             default = [])
      ]).

class(id = c_effect_apply_behavior, super = c_effect_response,
      [field(name = behavior,
             pred = atom,
             default = null)
      ]).

class(id = c_effect_create_persistent, super = c_effect_response,
      [field(name = initial_effect,
             pred = atom,
             default = null),
       field(name = final_effect,
             pred = atom,
             default = null),
       field(name = periodic_effect,
             pred = atom,
             default = null),
       field(name = periodic_count,
             pred = number,
             default = 0),
       field(name = periodic_duration,
             pred = number,
             default = 0)
      ]).

%% class(id = c_effect_destroy_persistent, super = c_effect_response,
%%      []).

%% class(id = c_effect_create_unit, super = c_effect_response,
%%      []).

class(id = c_effect_damage, super = c_effect_response,
      [field(name = amount,
             pred = number,
             default = 0)
      ]).

class(id = c_effect_enum_area, super = c_effect_response,
      [field(name = area,
             pred = number,
             default = 0),
       field(name = area_effect,
             pred = atom,
             default = null)
      ]).

class(id = c_effect_launch_missile, super = c_effect_response,
      [field(name = ammo_unit,
             pred = atom,
             default = null),
       field(name = launch_location,
             pred = atom,
             default = null),
       field(name = impact_location,
             pred = atom,
             default = null)
      ]).

class(id = c_effect_modify_unit, super = c_effect_response,
      [field(name = life,
             pred = is_struct(s_effect_modify_vital, 2),
             default = s_effect_modify_vital(change:0, change_fraction:0)),
       field(name = energy,
             pred = is_struct(s_effect_modify_vital, 2),
             default = s_effect_modify_vital(change:0, change_fraction:0))
      ]).

