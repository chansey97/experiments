
template(catalog = behavior, id = psi_storm_buff,
         [class = c_behavior_buff],     
         [name = "Psi Storm Buff",
          duration = 2,
          init_effect = null,
          final_effect = null,
          period = 1,
          period_count = -1,
          periodic_effect = psi_storm_damage
         ]).
