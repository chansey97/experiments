/* Template Class */

sub_class(c_abil, c_abil).
sub_class(c_abil_keyboard_move, c_abil).
sub_class(c_abil_keyboard_attack, c_abil).
sub_class(c_abil_move, c_abil).
sub_class(c_abil_attak, c_abil).
sub_class(c_abil_morph, c_abil).
 
sub_class(c_unit, c_unit).

is_sub_class_of(X,Y) :- sub_class(X,Y).
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

add_template_components(AID, c_abil_attack,Template) <=>
  c(AID, class, c_abil_attack),  
  c(AID, template, Template).

add_template_components(AID, c_abil_morph, Template) <=>
  c(AID, class, c_abil_morph),  
  c(AID, template, Template),
  %% TODO: morphing time and stages?
  c(AID, cooldown, 0).

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
  c(UID, abils, AIDs).

remove_template_components(UID, c_unit) \ c(UID, bounds, V) # passive <=> true.
remove_template_components(UID, c_unit) \ c(UID, life, V) # passive <=> true.
remove_template_components(UID, c_unit) \ c(UID, life_max, V) # passive <=> true.
remove_template_components(UID, c_unit) \ c(UID, energy, V) # passive <=> true.
remove_template_components(UID, c_unit) \ c(UID, energy_max, V) # passive <=> true.
remove_template_components(UID, c_unit) \ c(UID, speed, V) # passive <=> true.
remove_template_components(UID, c_unit) \ c(UID, abils, V) # passive <=> true.
remove_template_components(UID, c_unit) <=> true.

create_abil(Template, OwnerID, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  template_field_value_get(Template, class, Class),
  add_template_components(EID, Class, Template),  
  c(EID, owner_id, OwnerID).

create_unit(Template, X, Y, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  template_field_value_get(Template, class, Class),
  add_template_components(EID, Class, Template),
  c(EID, position, X-Y).

create_player(PID, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  c(EID, player, PID).

player_control_unit(PID, EID), c(EIDPlayer, player, PID) # passive, c(EID, template, _) # passive ==> 
  c(EIDPlayer, player_control, EID).


