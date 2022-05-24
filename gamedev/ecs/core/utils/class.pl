%% Abils 
sub_class(c_abil_keyboard_move, c_abil).
sub_class(c_abil_keyboard_attack, c_abil).
sub_class(c_abil_move, c_abil).
sub_class(c_abil_attak, c_abil).
sub_class(c_abil_morph, c_abil).
sub_class(c_abil_effect, c_abil).
sub_class(c_abil_effect_instant, c_abil_effect).
sub_class(c_abil_effect_target, c_abil_effect).

%% Weapon
sub_class(c_weapon_legacy, c_weapon).

%% Effect
sub_class(c_effect_response, c_effect).
sub_class(c_effect_damage, c_effect_response).
sub_class(c_effect_launch_missile, c_effect_response).
sub_class(c_effect_modify_unit, c_effect_response).

is_sub_class_of(X,X) :- !.
is_sub_class_of(X,Y) :- sub_class(X,Z), is_sub_class_of(Z,Y).
