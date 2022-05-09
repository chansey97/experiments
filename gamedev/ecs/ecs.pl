%% An ECS(Entity Component System) simulation via Constraint Handling Rules.
:- use_module(library(chr)).
:- use_module(library(yall)).

:- chr_constraint
  
  %% entity, component, system
  next_e/1,
  c/3,
  c/5,  
  update/2,
  
  %% utils
  get_components/2, one_c/1, collect_c/1,
  
  abil_create/3,  
  unit_create/4,  
  remove_unit_template_components/1,
  remove_component/2,  
  player_create/2,
  player_control_unit/2
  .

%% ps :-
%%     current_chr_constraint(Module:Name),
%%     format('constraint store contains ~w:~w~n', [Module, Name]),
%%     fail.
%% ps.


/* Template types */

%% abils
sub_type(abil_base, entity).
sub_type(abil_keyboard_move, abil_base).
sub_type(abil_keyboard_attack, abil_base).
sub_type(abil_move, abil_base).
sub_type(abil_attak, abil_base).
sub_type(abil_morph, abil_base).

%% units
sub_type(unit_base, entity).
sub_type(unit_standard, unit_base).


/* Template types & Components */

%% :- discontiguous t/3, t_c/3.

%% abils

add_abil_template_components(abil_keyboard_move, EID, Template, OwnerID) :-
  c(EID, type, abil_keyboard_move),  
  c(EID, template, Template),
  c(EID, owner_id, OwnerID).

add_abil_template_components(abil_keyboard_attack, EID, Template, OwnerID) :-
  c(EID, type, abil_keyboard_attack),  
  c(EID, template, Template),
  c(EID, owner_id, OwnerID).

add_abil_template_components(abil_move, EID, Template, OwnerID) :-
  c(EID, type, abil_move),  
  c(EID, template, Template),
  c(EID, owner_id, OwnerID),
  template_abil(Template, cooldown, Cooldown),
  c(EID, cooldown, 0),
  c(EID, cooldown_max, Cooldown).

add_abil_template_components(abil_attack, EID, Template, OwnerID) :-
  c(EID, type, abil_attack),  
  c(EID, template, Template),
  c(EID, owner_id, OwnerID).

add_abil_template_components(abil_morph, EID, Template, OwnerID) :-
  c(EID, type, abil_morph),  
  c(EID, template, Template),
  c(EID, owner_id, OwnerID),
  template_abil(Template, energy, Energy),
  template_abil(Template, cooldown, Cooldown),
  %% TODO: morphing time and stages?  
  c(EID, energy, Energy),
  c(EID, cooldown, 0),
  c(EID, cooldown_max, Cooldown).

%% weapon

%% units
add_unit_template_components(unit_standard, UID, Template) :-
  c(UID, template, Template),
  template_unit(Template, bounds, Bounds),
  template_unit(Template, life_starting, LifeStarting),  
  template_unit(Template, life_max, LifeMax),
  template_unit(Template, energy_starting, EnergyStarting),
  template_unit(Template, energy_max, EnergyMax),
  template_unit(Template, speed, Speed),
  template_unit(Template, abils, Abils),  
  c(UID, bounds, Bounds),
  c(UID, life, LifeStarting),
  c(UID, life_max, LifeMax),
  c(UID, energy, EnergyStarting),
  c(UID, energy_max, EnergyMax),
  c(UID, speed, Speed),
  % abils  
  maplist({UID}/[A,AID]>>abil_create(A, UID, AID), Abils, AIDs),
  c(UID, abils, AIDs),
  % template_components
  get_components(UID, Cs),
  setof(N, E^V^member(c(E, N, V), Cs), Ns),
  c(UID, template_components, Ns).


%% actor
  
/* Templates */

%% abils
template_abil(keyboard_move, type, abil_keyboard_move).
template_abil(keyboard_move, left_key, 37).
template_abil(keyboard_move, up_key, 38).
template_abil(keyboard_move, right_key, 39).
template_abil(keyboard_move, down_key, 40).

template_abil(move, type, abil_move).
template_abil(move, cooldown, 0).

template_abil(attack, type, abil_attack).

template_abil(morph_into_bear, type, abil_morph).
template_abil(morph_into_bear, unit_template, bear).
template_abil(morph_into_bear, energy, 50).
template_abil(morph_into_bear, cooldown, 10).
template_abil(morph_into_bear, template, bear).

%% units
template_unit(mage, type, unit_standard).
template_unit(mage, bounds, 1).
template_unit(mage, life_starting, 100).
template_unit(mage, life_max, 100).
template_unit(mage, energy_starting, 100).
template_unit(mage, energy_max, 100).
template_unit(mage, speed, 5).
template_unit(mage, abils, [keyboard_move, morph_into_bear]).

template_unit(bear, type, unit_standard).
template_unit(bear, bounds, 2).
template_unit(bear, life_starting, 500).
template_unit(bear, life_max, 500).
template_unit(bear, energy_starting, 0).
template_unit(bear, energy_max, 0).
template_unit(bear, speed, 7).
template_unit(bear, abils, [move]).

template_unit(tree, type, unit_standard).
template_unit(tree, bounds, 1).
template_unit(tree, life_starting, 100).
template_unit(tree, life_max, 100).
template_unit(tree, energy_starting, 0).
template_unit(tree, energy_max, 0).
template_unit(tree, speed, 0).
template_unit(tree, abils, []).


%% TODO: Does c(UID, abil_start, abil_morph, morph_into_bear, _) is a component? or event?

/* Systems */

input_system @ update(input, FID), c(_, player_control, UID) #passive ==>
  current_input(IO),
  read_string(IO, 2, S),
  format("update(input, FID=~w) ", [FID]),
  (   S="a\n"
      %% TODO: c/5 can be used for trigger
  ->  c(UID, abil_start, abil_morph, morph_into_bear, _) % assuming morph is a instant ability, so no cast system update needed
  ;   true   
  ).
input_system @ update(input, FID) <=> true.


abil_morph_start @
  c(UID, abils, AIDs) #passive,
  c(UID, energy, Energy) #passive,  
  c(AID, type, abil_morph) #passive,
  c(AID, energy, CostEnergy) #passive
  \
  c(UID, abil_start, abil_morph, T, _)
  <=>
    memberchk(AID, AIDs), % TODO: not efficient
    Energy >= CostEnergy |
    format("abil_morph_start 111 ~n"),
    Energy2 is Energy - CostEnergy,
    format("abil_morph_start 222 ~n"),    
    set_component(UID, energy, Energy2),
    format("abil_morph_start 333 ~n"),    
    c(UID, abil_execute, abil_morph, T, _).

abil_morph_execute @
  c(UID, energy, Energy) #passive,
  c(UID, energy_max, EnergyMax) #passive,  
  c(UID, life, Life) #passive,
  c(UID, life_max, LifeMax) #passive
  \
  c(UID, abil_execute, abil_morph, AbilTemplate, _)
  <=>
    template_abil(AbilTemplate, template, TemplateDst), !,
    template_unit(TemplateDst, life_max, LifeMaxDst), !,
    template_unit(TemplateDst, energy_max, EnergyMaxDst), !,   
    Life2 is (Life / LifeMax)*LifeMaxDst,    
    Energy2 is (Energy / EnergyMax)*EnergyMaxDst,    
    replace_unit_template_components(UID, TemplateDst),   
    set_component(UID, life, Life2), 
    set_component(UID, energy, Energy2).

%% movement_system @ update(move, FID), c(EID, velocity, V) #passive \ c(EID, position, X-Y) #passive <=>
%%   random(-1.0,1.0,Rand),
%%   X2 is X+Rand*V,
%%   Y2 is Y+Rand*V,
%%   c(EID, position, X2-Y2).
%% movement_system @ update(move, FID) <=> true.

%% render_system @ update(render, FID), c(EID, position, X-Y) #passive, c(EID, sprite, PNG) #passive ==>
%%   format("render frame:~w, eid:~w, ~w at (~w, ~w) ~n", [FID,EID,PNG,X,Y]).
%% movement_system @ update(render, FID) <=> true.

/* Utils */

%% Queryin components by EID

get_components(EID, Cs), c(EID, N, V) # passive ==> one_c(c(EID, N, V)).
get_components(EID, Cs) <=> collect_c(Cs).
collect_c(Cs), one_c(C) # passive <=> Cs = [C|Cs1], collect_c(Cs1).
collect_c(Cs) <=> Cs=[].

is_sub_type_of(X,Y) :- sub_type(X,Y).
is_sub_type_of(X,Y) :- sub_type(X,Z), is_sub_type_of(Z,Y).

abil_create(Template, OwnerID, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),  
  template_abil(Template, type, AbilType), !,
  add_abil_template_components(AbilType, EID, Template, OwnerID).

unit_create(Template, X, Y, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  template_unit(Template, type, UnitType), !,  
  add_unit_template_components(UnitType, EID, Template), !,
  c(EID, position, X-Y).



remove_unit_template_components(UID), c(UID, template_components, Cs) # passive \ c(UID, C, _) <=> memberchk(C, Cs) | true.
remove_unit_template_components(UID), c(UID, template_components, Cs) # passive <=> true.

%% TODO:
%% should we delete abil entity?
%% perhaps we could define remove_unit_template_components for each unit type
%% which means explictly delete, since we also need destory unit method.
%% Then we no longer need `template-components`.

replace_unit_template_components(UID, T) :-
  remove_unit_template_components(UID),
  template_unit(T, type, UnitType), !,
  add_unit_template_components(UnitType, UID, T), !.

player_create(PID, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  c(EID, player, PID).

player_control_unit(PID, EID), c(EIDPlayer, player, PID) # passive, c(EID, template, _) # passive ==> 
  c(EIDPlayer, player_control, EID).


%% TODO: consider about multiple values components
%% e.g. abils which should be use multiple components instead of one component with a list value.
remove_component(EID, C), c(EID, C, _) <=> true.
set_component(EID, C, V) :-
  remove_component(EID, C),
  c(EID, C, V).


%% /* Main */

%% world_init :-
%%   next_e(0),
%%   player_create(0, _),
%%   unit_create(mage, 10, 20, EID0),
%%   unit_create(bear, 15, 30, _),
%%   unit_create(tree, 5, 5, _),
%%   unit_create(tree, 7, 7, _),
%%   player_control_unit(0, EID0).

%% update(FID) :-
%%   update(input, FID),
%%   update(move, FID).

%% draw(FID) :-
%%   update(render, FID).

%% game_loop(FID) :-
%%   update(FID),
%%   draw(FID),
%%   FID2 is FID+1,
%%   game_loop(FID2).

%% main :- world_init, game_loop(1).





%% ?- main.


%% ?- next_e(0), unit_create(mage, 10, 20, EID0).
%@ EID0 = 0,
%@ next_e(3),
%@ c(0,position,10-20),
%@ c(0,template_components,[abils,bounds,energy,energy_max,life,life_max,speed,template]),
%@ c(0,abils,[1,2]),
%@ c(2,cooldown_max,10),
%@ c(2,cooldown,0),
%@ c(2,energy,50),
%@ c(2,owner_id,0),
%@ c(2,template,morph_into_bear),
%@ c(2,type,abil_morph),
%@ c(1,owner_id,0),
%@ c(1,template,keyboard_move),
%@ c(1,type,abil_keyboard_move),
%@ c(0,speed,5),
%@ c(0,energy_max,100),
%@ c(0,energy,100),
%@ c(0,life_max,100),
%@ c(0,life,100),
%@ c(0,bounds,1),
%@ c(0,template,mage).



%% ?- next_e(0), unit_create(mage, 10, 20, EID0),
%%    replace_unit_template_components(EID0, bear).
%@ EID0 = 0,
%@ next_e(4),
%@ c(0,template_components,[abils,bounds,energy,energy_max,life,life_max,position,speed,template]),
%@ c(0,abils,[3]),
%@ c(3,cooldown_max,0),
%@ c(3,cooldown,0),
%@ c(3,owner_id,0),
%@ c(3,template,move),
%@ c(3,type,abil_move),
%@ c(0,speed,7),
%@ c(0,energy_max,0),
%@ c(0,energy,0),
%@ c(0,life_max,500),
%@ c(0,life,500),
%@ c(0,bounds,2),
%@ c(0,template,bear),
%@ c(0,position,10-20),
%@ c(2,cooldown_max,10),
%@ c(2,cooldown,0),
%@ c(2,energy,50),
%@ c(2,owner_id,0),
%@ c(2,template,morph_into_bear),
%@ c(2,type,abil_morph),
%@ c(1,owner_id,0),
%@ c(1,template,keyboard_move),
%@ c(1,type,abil_keyboard_move).




%% ?- next_e(0),
%%    unit_create(mage, 10, 20, EID0),
%%    unit_create(bear, 15, 30, EID1),
%%    unit_create(tree, 5, 5, EID2),
%%    unit_create(tree, 7, 7, EID3).
%@ EID0 = 0,
%@ EID1 = 3,
%@ EID2 = 5,
%@ EID3 = 6,
%@ next_e(7),
%@ c(6,position,7-7),
%@ c(6,template_components,[abils,bounds,energy,energy_max,life,life_max,speed,template]),
%@ c(6,abils,[]),
%@ c(6,speed,0),
%@ c(6,energy_max,0),
%@ c(6,energy,0),
%@ c(6,life_max,100),
%@ c(6,life,100),
%@ c(6,bounds,1),
%@ c(6,template,tree),
%@ c(5,position,5-5),
%@ c(5,template_components,[abils,bounds,energy,energy_max,life,life_max,speed,template]),
%@ c(5,abils,[]),
%@ c(5,speed,0),
%@ c(5,energy_max,0),
%@ c(5,energy,0),
%@ c(5,life_max,100),
%@ c(5,life,100),
%@ c(5,bounds,1),
%@ c(5,template,tree),
%@ c(3,position,15-30),
%@ c(3,template_components,[abils,bounds,energy,energy_max,life,life_max,speed,template]),
%@ c(3,abils,[4]),
%@ c(4,cooldown_max,0),
%@ c(4,cooldown,0),
%@ c(4,owner_id,3),
%@ c(4,template,move),
%@ c(4,type,abil_move),
%@ c(3,speed,7),
%@ c(3,energy_max,0),
%@ c(3,energy,0),
%@ c(3,life_max,500),
%@ c(3,life,500),
%@ c(3,bounds,2),
%@ c(3,template,bear),
%@ c(0,position,10-20),
%@ c(0,template_components,[abils,bounds,energy,energy_max,life,life_max,speed,template]),
%@ c(0,abils,[1,2]),
%@ c(2,cooldown_max,10),
%@ c(2,cooldown,0),
%@ c(2,energy,50),
%@ c(2,owner_id,0),
%@ c(2,template,morph_into_bear),
%@ c(2,type,abil_morph),
%@ c(1,owner_id,0),
%@ c(1,template,keyboard_move),
%@ c(1,type,abil_keyboard_move),
%@ c(0,speed,5),
%@ c(0,energy_max,100),
%@ c(0,energy,100),
%@ c(0,life_max,100),
%@ c(0,life,100),
%@ c(0,bounds,1),
%@ c(0,template,mage).



