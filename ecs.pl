%% An ECS(Entity Component System) simulation via Constraint Handling Rules.
:- use_module(library(chr)).

:- chr_constraint
  update_input/1, update_cast/1, update_move/1, update_render/1, 
  position/3, health/2, mana/2, velocity/2,
  has_armor/1,
  can_attack/1, can_magic/1,
  is_enemy/1, is_hero/1,
  sprite/2,
  is_mage/1, is_bear/1, is_tree/1,
  cast/2,
  key_state/3. 

%% keybord_system @ update_keybord(FID) ==>

%% input_system @ update_input(FID), key_state(FID0,'a',up), key_state(FID,'a',down) ==> 
%%   FID =:= FID0 + 1 | cast(0,morph).
%% input_system @ update_input(FID) <=> true.

%% N.B. We may need to check something like `not is_bear`.
%% In that case, constraint store need to be test, it is a kind of entailment test.
cast_system @ update_cast(FID), is_hero(EID), can_magic(EID) \ mana(EID, M) #passive, cast(EID,morph) #passive, sprite(EID,_) #passive <=>
  M >= 20 |
  M2 = M-20, mana(EID, M2),
  is_bear(EID), health(EID,500), velocity(EID,7), sprite(EID,"bear.png").    
cast_system @ update_cast(FID) <=> true.

movement_system @ update_move(FID), velocity(EID,V) \ position(EID,X,Y) #passive <=>
  random(-1.0,1.0,Rand), X2 is X+Rand*V, Y2 is Y+Rand*V,
  position(EID,X2,Y2).
movement_system @ update_move(FID) <=> true.

render_system @ update_render(FID), position(EID,X,Y), sprite(EID,PNG) ==>
  format("render frame:~w, eid:~w, ~w at (~w, ~w) ~n", [FID,EID,PNG,X,Y]).
movement_system @ update_render(FID) <=> true.

create_tree(EID,X,Y) :-
  is_tree(EID), position(EID,X,Y), sprite(EID,"tree.png").
create_mage(EID,X,Y) :-
  is_mage(EID), position(EID,X,Y), health(EID,100), mana(EID,100), velocity(EID,5), can_magic(EID), is_hero(EID), sprite(EID,"mage.png").
create_bear(EID,X,Y) :-
  is_bear(EID), position(EID,X,Y), health(EID,500), velocity(EID,7), can_attack(EID), is_enemy(EID), sprite(EID,"bear.png").  

create_world :- create_mage(0,10,20), create_bear(1,15,30), create_tree(2,1,1), create_tree(3,2,2).

update(FID) :-
  update_input(FID),
  update_cast(FID), update_move(FID).

draw(FID) :-
  update_render(FID).

%% Press anykey to next frame, press "a" to cast spell
game_loop(FID) :-
  current_input(IO),read_string(IO, 2, S),
  format("game_loop input ~w", [S]),
  (   S="a\n"
  ->  cast(0,morph)
  ;   true   
  ),
  update(FID),
  draw(FID),
  FID2 is FID+1,
  game_loop(FID2).

%% ?- create_world,update(1),draw(1),cast(0,morph),update(2),draw(2).
