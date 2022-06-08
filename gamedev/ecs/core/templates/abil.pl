
template(catalog = abil, id = t_abil_move,
         [class = c_abil_move],     
         [name = "t_abil_move",
          cost_cooldown = 0
          ]).

template(catalog = abil, id = t_abil_attack,
         [class = c_abil_attack],     
         [name = "t_abil_attack",
          cost_cooldown = 0
         ]).

template(catalog = abil, id = t_abil_keyboard_move,
         [class = c_abil_keyboard_move],     
         [name = "t_abil_keyboard_move",
          left_key = 37,
          up_key = 38,
          right_key = 39,
          down_key = 40
         ]).

template(catalog = abil, id = t_abil_effect,
         [class = c_abil_effect],     
         [name = "t_abil_effect",
          transient = false,
          cost_energy = 0,
          cost_cooldown = 0,
          effects = []
         ]).

template(catalog = abil, id = t_abil_effect_instant,
         [class = c_abil_effect_instant,
          parent = t_abil_effect],     
         [name = "t_abil_effect_instant",
          transient = true
         ]).

template(catalog = abil, id = t_abil_effect_target,
         [class = c_abil_effect_target,
          parent = t_abil_effect],     
         [name = "t_abil_effect_target",
          transient = true
         ]).

template(catalog = abil, id = t_abil_morph,
         [class = c_abil_morph],     
         [name = "t_abil_effect_target",
          cost_energy = 0,
          cost_energy = 0,
          template = null
         ]).
