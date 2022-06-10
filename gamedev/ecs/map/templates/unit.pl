%% TODO: emp_weapon and yamato_weapon as bullet unit.

template(catalog = unit, id = bear,
         [class = c_unit],     
         [name = "Bear",
          bounds = 2,
          life_starting = 500,
          life_max = 500,
          energy_starting = 0,
          energy_max = 0,
          speed = 7,
          abils = [move, attack],
          weapons = [bear_claws]
         ]).

template(catalog = unit, id = mage,
         [class = c_unit],     
         [name = "Mage",
          bounds = 1,
          life_starting = 100,
          life_max = 100,
          energy_starting = 100,
          energy_max = 100,
          speed = 5,
          abils = [keyboard_move, morph_bear, self_heal]
         ]).

template(catalog = unit, id = mage_dup_abils,
         [class = c_unit],     
         [name = "Mage Duplicate Abils",
          bounds = 1,
          life_starting = 100,
          life_max = 100,
          energy_starting = 100,
          energy_max = 100,
          speed = 5,
          abils = [keyboard_move, morph_bear, self_heal, self_heal]
         ]).

template(catalog = unit, id = tree,
         [class = c_unit],     
         [name = "Tree",
          bounds = 1,
          life_starting = 100,
          life_max = 100,
          energy_starting = 0,
          energy_max = 0,
          speed = 0      
         ]).

template(catalog = unit, id = test_unit,
         [class = c_unit],     
         [name = "test_unit",
          bounds = 2,
          life_starting = 500,
          life_max = 500,
          energy_starting = 0,
          energy_max = 0,
          speed = 7,
          abils = [move],
          weapons = [bear_claws]
         ]).
