/* Template Class */

sub_class(c_abil_keyboard_move, c_abil).
sub_class(c_abil_keyboard_attack, c_abil).
sub_class(c_abil_move, c_abil).
sub_class(c_abil_attak, c_abil).
sub_class(c_abil_morph, c_abil).
sub_class(c_abil_effect, c_abil).
sub_class(c_abil_effect_instant, c_abil_effect).
sub_class(c_abil_effect_target, c_abil_effect).

sub_class(c_weapon_legacy, c_weapon).

sub_class(c_effect_response, c_effect).
sub_class(c_effect_damage, c_effect_response).
sub_class(c_effect_launch_missile, c_effect_response).
sub_class(c_effect_modify_unit, c_effect_response).

is_sub_class_of(X,X) :- !.
is_sub_class_of(X,Y) :- sub_class(X,Z), is_sub_class_of(Z,Y).

/* Template */

template_class_get(Template, Class) :-
  template(Catalog, Template, class, Class).

template_parent_get(Template, Parent) :-
  template(Template, parent, Parent).

template_field_value_get(Template, Field, Value) :-
  (   template(Template, Field, Value) 
  ->  true  
  ;   template_parent_get(Template, Parent),
      template_field_value_get(Parent, Field, Value)
  ).

/* ECS */

get_components(EID, Cs), c(EID, N, V) # passive ==> one_c(c(EID, N, V)).
get_components(EID, Cs) <=> collect_c(Cs).
collect_c(Cs), one_c(C) # passive <=> Cs = [C|Cs1], collect_c(Cs1).
collect_c(Cs) <=> Cs=[].

set_component(EID, N, V) <=> remove_component(EID, N), c(EID, N, V).

%% TODO: Assuming there is no multiple values components, but it should be taken into account.
%% e.g. abils which should be use multiple components instead of one component with a list value.
remove_component(EID, N), c(EID, N, _) # passive <=> true.


/* Entities */

%% Entities' Template Components

%% Unit
add_template_components(UID, c_unit, Template) <=>
  c(UID, template, Template),
  template_field_value_get(Template, bounds, Bounds),
  template_field_value_get(Template, life_starting, LifeStarting),  
  template_field_value_get(Template, life_max, LifeMax),
  template_field_value_get(Template, energy_starting, EnergyStarting),
  template_field_value_get(Template, energy_max, EnergyMax),
  template_field_value_get(Template, speed, Speed),
  template_field_value_get(Template, abils, Abils),
  c(UID, bounds, Bounds),
  c(UID, life, LifeStarting),
  c(UID, life_max, LifeMax),
  c(UID, energy, EnergyStarting),
  c(UID, energy_max, EnergyMax),
  c(UID, speed, Speed),
  % abils  
  maplist({UID}/[A, AID]>>create_abil(A, UID, AID), Abils, AIDs),
  c(UID, abils, AIDs),
  %% weapons
  maplist({UID}/[W, WID]>>create_weapon(W, UID, WID), Wbils, WIDs),
  c(UID, weapons, WIDs).

remove_template_components(UID, c_unit) \ c(UID, bounds, V) # passive <=> true.
remove_template_components(UID, c_unit) \ c(UID, life, V) # passive <=> true.
remove_template_components(UID, c_unit) \ c(UID, life_max, V) # passive <=> true.
remove_template_components(UID, c_unit) \ c(UID, energy, V) # passive <=> true.
remove_template_components(UID, c_unit) \ c(UID, energy_max, V) # passive <=> true.
remove_template_components(UID, c_unit) \ c(UID, speed, V) # passive <=> true.
remove_template_components(UID, c_unit) \ c(UID, abils, V) # passive <=> true.
remove_template_components(UID, c_unit) <=> true.

%% Abil
add_template_components(AID, c_abil_keyboard_move, Template) <=>
  c(AID, class, c_abil_keyboard_move),  
  c(AID, template, Template).

add_template_components(AID, c_abil_keyboard_attack, Template) <=>
  c(AID, class, c_abil_keyboard_attack),  
  c(AID, template, Template).

add_template_components(AID, c_abil_move, Template) <=>
  c(AID, class, c_abil_move),
  c(AID, template, Template),
  c(AID, cooldown, 0).

add_template_components(AID, c_abil_attack, Template) <=>
  c(AID, class, c_abil_attack),  
  c(AID, template, Template).

add_template_components(AID, c_abil_morph, Template) <=>
  c(AID, class, c_abil_morph),  
  c(AID, template, Template),
  %% TODO: morphing time and stages?
  c(AID, cooldown, 0).

%% Weapon
add_template_components(WID, c_weapon_legacy, Template) <=>
  c(WID, class, c_weapon_legacy),  
  c(WID, template, Template),
  c(WID, time_point, 0).

%% Effect
add_template_components(EffID, c_effect_damage, Template) <=>
  c(EffID, class, c_effect_damage),  
  c(EffID, template, Template).

add_template_components(EffID, t_effect_launch_missile, Template) <=>
  c(EffID, class, c_effect_launch_missile),  
  c(EffID, template, Template).

add_template_components(EffID, t_effect_modify_unit, Template) <=>
  c(EffID, class, t_effect_modify_unit),  
  c(EffID, template, Template).

%% Entities Interfaces

%% Unit
create_unit(Template, X, Y, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  template_field_value_get(Template, class, Class),
  add_template_components(EID, Class, Template),
  c(EID, position, X-Y).

%% Abil
create_abil(Template, OwnerID, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  template_field_value_get(Template, class, Class),
  add_template_components(EID, Class, Template),  
  c(EID, owner_id, OwnerID).

%% Weapon
create_weapon(Template, OwnerID, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  template_field_value_get(Template, class, Class),
  add_template_components(EID, Class, Template),  
  c(EID, owner_id, OwnerID).

%% Effect
%% N.B. CasterID can be PlayerID or UnitID ; TargetID can be PointID or UnitID,
%% Because of ECS, no need to distinguish them via interface names like below:
%% create_effect_by_player_at_point/4,
%% create_effect_by_player_at_unit/4,
%% create_effect_by_unit_at_point/4,
%% create_effect_by_unit_at_unit/4,
create_effect(Template, CasterID, TargetID, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  template_field_value_get(Template, class, Class),
  add_template_components(EID, Class, Template),
  c(EID, caster_id, CasterID),
  c(EID, target_id, TargetID).

%% Point
create_point(X, Y, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  c(EID, point),
  c(EID, position, X-Y).  

%% Player
create_player(PlayerNo, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  c(EID, player, Player).

player_control_unit(PlayerNo, EID), c(EIDPlayer, player, PlayerNo) # passive, c(EID, template, _) # passive ==> 
  c(EIDPlayer, player_control, EID).

