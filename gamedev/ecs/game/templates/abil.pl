
template(catalog = abil, id = move,
         [class = c_abil_move],     
         [name = "Move",
          cost_cooldown = 0
         ]).

template(catalog = abil, id = attack,
         [class = c_abil_attack],     
         [name = "Attack",
          cost_cooldown = 0
         ]).

template(catalog = abil, id = keyboard_move,
         [class = c_abil_keyboard_move],     
         [name = "Keyboard Move"
         ]).

template(catalog = abil, id = morph_bear,
         [class = c_abil_morph],     
         [name = "Morph Bear",
          cost_energy = 50,
          cost_cooldown = 5,          
          template = bear
         ]).

template(catalog = abil, id = self_heal,
         [class = c_abil_effect_instant,
          parent = t_abil_effect_instant],     
         [name = "Self Heal",
          transient = true,          
          effects = [self_heal_modify_unit]
         ]).

template(catalog = abil, id = psi_storm,
         [class = c_abil_effect_target,
          parent = t_abil_effect_target],     
         [name = "Psi Storm",     
          cost_energy = 75,
          cost_cooldown = 3,
          transient = false,          
          range = 7,
          effects = [psi_storm_persistent]
         ]).

