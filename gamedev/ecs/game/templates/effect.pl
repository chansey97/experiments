
template(catalog = effect, id = bear_claws_damage,
         [class = c_effect_damage,
          parent = t_effect_damage],     
         [name = "Bear Claws Damage",
          amount = 8
         ]).

template(catalog = effect, id = self_heal_modify_unit,
         [class = c_effect_modify_unit,
          parent = t_effect_modify_unit],     
         [name = "Self Heal Modify Unit",
          life = s_effect_modify_vital(change:100, change_fraction:0)
         ]).

template(catalog = effect, id = emp_launch_missile,
         [class = c_effect_launch_missile,
          parent = t_effect_launch_missile],     
         [name = "EMP Launch Missile",
          ammo_unit = emp_weapon,
          launch_location = unit,
          impact_location = point,
          impact_effect = emp_search
         ]).

template(catalog = effect, id = emp_search,
         [class = c_effect_launch_missile,
          parent = t_effect_enum_area],     
         [name = "EMP Search",
          area = 1.5,
          area_effect = emp_set
         ]).

template(catalog = effect, id = emp_damage,
         [class = c_effect_damage,
          parent = t_effect_damage],     
         [name = "EMP Damage",
          amount = 100
         ]).

template(catalog = effect, id = emp_modify_unit,
         [class = c_effect_modify_unit,
          parent = t_effect_modify_unit],     
         [name = "EMP Modify Unit",
          energy = s_effect_modify_vital(change:-100, change_fraction:0)
         ]).

%% c_effect_set means list of effects
template(catalog = effect, id = emp_set,
         [class = c_effect_set,
          parent = t_effect_set],     
         [name = "EMP Set",
          effects = [emp_damage, emp_modify_unit]
         ]).

template(catalog = effect, id = psi_storm_apply_buff,
         [class = c_effect_apply_behavior,
          parent = t_effect_apply_behavior],     
         [name = "Psi Storm Apply Buff",
          behavior = psi_storm
         ]).

template(catalog = effect, id = psi_storm_damage,
         [class = c_effect_damage,
          parent = t_effect_damage],     
         [name = "Psi Storm Damage",
          amount = 10
         ]).

template(catalog = effect, id = psi_storm_persistent,
         [class = c_effect_create_persistent],     
         [name = "Psi Storm Persistent",
          initial_effect = psi_storm_search,
          periodic_effect = psi_storm_search,
          periodic_count = 6,
          periodic_duration = 1
         ]).

template(catalog = effect, id = psi_storm_search,
         [class = c_effect_enum_area],     
         [name = "Psi Storm Search",
          area = 1.5,
          area_effect = psi_storm_apply_buff
         ]).

template(catalog = effect, id = yamato_damage,
         [class = c_effect_damage],     
         [name = "Yamato Damage",
          amount = 250
         ]).

template(catalog = effect, id = yamato_launch_missile,
         [class = c_effect_launch_missile],     
         [name = "Yamato Launch Missile",
          ammo_unit = yamato_weapon,
          launch_location = unit,
          impact_location = unit,
          impact_effect = yamato_damage
         ]).
