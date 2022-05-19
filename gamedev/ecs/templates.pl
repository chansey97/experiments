
%% TODO: Read from external files?

/* Core Templates */

%% Units

%% t_unit
template(t_unit, class, c_unit).
template(t_unit, bounds, 1).
template(t_unit, life_starting, 100).
template(t_unit, life_max, 100).
template(t_unit, energy_starting, 100).
template(t_unit, energy_max, 100).
template(t_unit, speed, 0).
template(t_unit, abils, []).

%% Abils

%% t_abil_keyboard_move
template(t_abil_keyboard_move, class, c_abil_keyboard_move).
template(t_abil_keyboard_move, left_key, 37).
template(t_abil_keyboard_move, up_key, 38).
template(t_abil_keyboard_move, right_key, 39).
template(t_abil_keyboard_move, down_key, 40).

%% t_abil_move
template(t_abil_move, class, c_abil_move).
template(t_abil_move, cost_cooldown, 0).

%% t_abil_attack
template(t_abil_attack, class, c_abil_attack).
template(t_abil_attack, cost_cooldown, 0).

%% t_abil_morph
template(t_abil_morph, class, c_abil_morph).
template(t_abil_morph, cost_energy, 50).
template(t_abil_morph, cost_cooldown, 10).
template(t_abil_morph, template, unknown).

/* Specific Game Templates */

%% Units

%% mage
template(mage, class, c_unit).
template(mage, parent, t_unit).
template(mage, speed, 5).
template(mage, abils, [keyboard_move, morph_bear]).

%% mage with duplicate abils
template(mage_dup_abils, class, c_unit).
template(mage_dup_abils, parent, t_unit).
template(mage_dup_abils, speed, 5).
template(mage_dup_abils, abils, [keyboard_move, morph_bear, morph_bear]).

%% bear
template(bear, class, c_unit).
template(bear, parent, t_unit).
template(bear, bounds, 2).
template(bear, life_starting, 500).
template(bear, life_max, 500).
template(bear, energy_starting, 0).
template(bear, energy_max, 0).
template(bear, speed, 7).
template(bear, abils, [move]).

%% tree
template(tree, class, c_unit).
template(tree, parent, t_unit).
template(tree, energy_starting, 0).
template(tree, energy_max, 0).


%% Abils

%% keyboard_move
template(keyboard_move, class, c_abil_keyboard_move).
template(keyboard_move, parent, t_abil_keyboard_move).

%% move
template(move, class, c_abil_move).
template(move, parent, t_abil_move).

%% attack
template(attack, class, c_abil_attack).
template(attack, parent, t_abil_attack).

%% morph_bear
template(morph_bear, class, c_abil_morph).
template(morph_bear, parent, t_abil_morph).
template(morph_bear, template, bear).
