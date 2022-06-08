
template(catalog = effect, id = t_effect_damage,
         [class = c_effect_damage],     
         [name = "t_effect_damage",
          amount = 10
         ]).

template(catalog = effect, id = t_effect_launch_missile,
         [class = c_effect_launch_missile],     
         [name = "t_effect_damage",
          ammo_unit = null
         ]).

template(catalog = effect, id = t_effect_modify_unit,
         [class = c_effect_modify_unit],     
         [name = "t_effect_modify_unit",
          life = s_effect_modify_vital(change:0, change_fraction:0),
          energy = s_effect_modify_vital(change:0, change_fraction:0)
         ]).

%% t_effect_enum_area