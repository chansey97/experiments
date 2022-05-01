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


%% ?- create_world, game_loop(1).
%@ |:  
%@ game_loop input  
%@ render frame:1, eid:0, mage.png at (13.102860554019387, 23.102860554019387) 
%@ render frame:1, eid:1, bear.png at (10.433501820862503, 25.433501820862503) 
%@ render frame:1, eid:3, tree.png at (2, 2) 
%@ render frame:1, eid:2, tree.png at (1, 1) 
%@ |:  
%@ game_loop input  
%@ render frame:2, eid:1, bear.png at (8.260938770171123, 23.260938770171123) 
%@ render frame:2, eid:0, mage.png at (17.815774614257755, 27.815774614257755) 
%@ render frame:2, eid:3, tree.png at (2, 2) 
%@ render frame:2, eid:2, tree.png at (1, 1) 
%@ |:  
%@ game_loop input  
%@ render frame:3, eid:0, mage.png at (17.21869537071213, 27.21869537071213) 
%@ render frame:3, eid:1, bear.png at (3.249953773985373, 18.249953773985375) 
%@ render frame:3, eid:3, tree.png at (2, 2) 
%@ render frame:3, eid:2, tree.png at (1, 1) 
%@ |: a
%@ game_loop input a
%@ render frame:4, eid:1, bear.png at (7.741928767925851, 22.741928767925852) 
%@ render frame:4, eid:0, bear.png at (21.20683092216393, 31.20683092216393) 
%@ render frame:4, eid:3, tree.png at (2, 2) 
%@ render frame:4, eid:2, tree.png at (1, 1) 
%@ |:  
%@ game_loop input  
%@ render frame:5, eid:0, bear.png at (17.316575536036588, 27.316575536036588) 
%@ render frame:5, eid:1, bear.png at (3.9896393440394755, 18.989639344039478) 
%@ render frame:5, eid:3, tree.png at (2, 2) 
%@ render frame:5, eid:2, tree.png at (1, 1) 
%@ |: 
