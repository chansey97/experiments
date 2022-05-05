%% An ECS(Entity Component System) simulation via Constraint Handling Rules.
:- use_module(library(chr)).

:- chr_constraint
  
  %% entity, component, system
  next_e/1,
  c/3,
  update/2,
  
  %% utils
  unit_create/4,  
  remove_template_components/2,
  remove_component/2,  
  player_create/2,
  player_control_unit/2
  .

/* Templates & Components*/

:- discontiguous t/3, t_c/3.

%% mage
t(mage, bounds, 1).
t(mage, life_starting, 100).
t(mage, life_max, 100).
t(mage, energy_starting, 100).
t(mage, energy_max, 100).
t(mage, speed, 5).
t(mage, sprite, "mage.png").
t_c(mage, template, mage).
t_c(mage, bounds, V) :- t(mage, bounds, V2), V=V2.
t_c(mage, life, V) :- t(mage, life_starting, V2), V=V2.
t_c(mage, life_max, V) :- t(mage, life_max, V2), V=V2.
t_c(mage, energy, V) :- t(mage, energy_starting, V2), V=V2.
t_c(mage, energy_max, V) :- t(mage, energy_max, V2), V=V2.
t_c(mage, sprite, V) :- t(mage, sprite, V2), V=V2.

%% bear
t(bear, bounds, 2).
t(bear, life_starting, 500).
t(bear, life_max, 500).
t(bear, speed, 7).
t(bear, sprite, "bear.png").
t_c(bear, template, bear).
t_c(bear, bounds, V) :- t(bear, bounds, V2), V=V2.
t_c(bear, life, V) :- t(bear, life_starting, V2), V=V2.
t_c(bear, life_max, V) :- t(bear, life_max, V2), V=V2.
t_c(bear, sprite, V) :- t(bear, sprite, V2), V=V2.

%% tree
t(tree, bounds, 1).
t(tree, sprite, "tree.png").
t_c(tree, template, tree).
t_c(tree, bounds, V) :- t(tree, bounds, V2), V=V2.
t_c(tree, sprite, V) :- t(tree, sprite, V2), V=V2.

/* Systems */

input_system @ update(input, FID), c(_, player_control, EID) #passive ==>
  current_input(IO), read_string(IO, 2, S),
  format("update(input, FID=~w) ", [FID]),
  (   S="a\n"
  ->  c(EID, cast_begin, abil_morph(bear)) % assuming morph is a instant ability, so no cast system update needed
  ;   true   
  ).
input_system @ update(input, FID) <=> true.

cast_system_notify @
  c(EID, template, Template) #passive,
  c(EID, energy, Energy) #passive,
  c(EID, energy_max, EnergyMax) #passive,  
  c(EID, life, Life) #passive,
  c(EID, life_max, LifeMax) #passive \
  c(EID, cast_begin, abil_morph(TemplateDst)) <=>
  Energy >= 20 |
  t_c(TDst, life_max, LifeMaxDst),
  t_c(TDst, energy_max, EnergyMaxDst),
  Life2 is (Life / LifeMax)*LifeMaxDst,
  Energy2 is (Energy / EnergyMax)*EnergyMaxDst,
  replace_template_components(EID, Template, TemplateDst),
  set_component(EID, life, Life2),
  set_component(EID, energy, Energy2).  

%% cast_system @ update(cast, FID), c(EID, cast_begin, XXX) #passive, energy(EID, Energy) #passive <=>
%%   Energy >= 20 |
%%   Energy2 = Energy-20, c(EID, energy, Energy2).    
%% cast_system @ update(cast, FID) <=> true.

movement_system @ update(move, FID), c(EID, velocity, V) #passive \ c(EID, position, X-Y) #passive <=>
  random(-1.0,1.0,Rand),
  X2 is X+Rand*V,
  Y2 is Y+Rand*V,
  c(EID, position, X2-Y2).
movement_system @ update(move, FID) <=> true.

render_system @ update(render, FID), c(EID, position, X-Y) #passive, c(EID, sprite, PNG) #passive ==>
  format("render frame:~w, eid:~w, ~w at (~w, ~w) ~n", [FID,EID,PNG,X,Y]).
movement_system @ update(render, FID) <=> true.

/* Utils */

add_template_components(EID, T) :- foreach(t_c(T, N, V), c(EID, N, V)).

remove_template_components(EID, T) \ c(EID, N, V) <=> t_c(T,N,_) | true.
remove_template_components(EID, T) <=> true.

replace_template_components(EID, TSrc, TDst) :-
  remove_template_components(EID, TSrc),
  add_template_components(EID, TDst).

remove_component(EID, N), c(EID, N, V) <=> true.

set_component(EID, N, V) :-
  remove_component(EID, N),
  c(EID, N, V).

unit_create(T,X,Y,EID), next_e(ID) <=>
  EID=ID,
  add_template_components(EID, T),
  c(EID, position, X-Y),
  NextID is ID+1, next_e(NextID).

player_create(PID, EID), next_e(ID) <=>
  EID=ID,
  c(EID, player, PID),
  NextID is ID+1, next_e(NextID).

player_control_unit(PID, EID), c(EIDPlayer, player, PID), c(EID, template, _) ==> 
  c(EIDPlayer, player_control, EID).

/* Main */

world_init :-
  next_e(0),
  player_create(0, _),
  unit_create(mage, 10, 20, EID0),
  unit_create(bear, 15, 30, _),
  unit_create(tree, 5, 5, _),
  unit_create(tree, 7, 7, _),
  player_control_unit(0, EID0).

update(FID) :-
  update(input, FID),
  update(move, FID).

draw(FID) :-
  update(render, FID).

game_loop(FID) :-
  update(FID),
  draw(FID),
  FID2 is FID+1,
  game_loop(FID2).

main :- world_init, game_loop(1).


%% ?- main.


%% ?- next_e(0),
%%    unit_create(mage, 10, 20, EID0),
%%    unit_create(bear, 15, 30, EID1),
%%    unit_create(tree, 5, 5, EID2),
%%    unit_create(tree, 7, 7, EID3).
%@ EID0 = 0,
%@ EID1 = 1,
%@ EID2 = 2,
%@ EID3 = 3,
%@ next_e(4),
%@ c(3,position,7-7),
%@ c(3,sprite,tree.png),
%@ c(3,bounds,1),
%@ c(3,template,tree),
%@ c(2,position,5-5),
%@ c(2,sprite,tree.png),
%@ c(2,bounds,1),
%@ c(2,template,tree),
%@ c(1,position,15-30),
%@ c(1,sprite,bear.png),
%@ c(1,life_max,500),
%@ c(1,life,500),
%@ c(1,bounds,2),
%@ c(1,template,bear),
%@ c(0,position,10-20),
%@ c(0,sprite,mage.png),
%@ c(0,energy_max,100),
%@ c(0,energy,100),
%@ c(0,life_max,100),
%@ c(0,life,100),
%@ c(0,bounds,1),
%@ c(0,template,mage).

%% ?- next_e(0),
%%    unit_create(mage, 10, 20, EID0),
%%    remove_template_components(EID0, mage).
%@ EID0 = 0,
%@ next_e(1),
%@ c(0,position,10-20).


