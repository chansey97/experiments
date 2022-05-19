%% An ECS(Entity Component System) simulation via Constraint Handling Rules.
:- use_module(library(chr)).
:- use_module(library(yall)).

:- debug.

:- chr_constraint

  %% TODO: template also use CHR
  %% template_class_get/3, 
  %% template_parent_get/3, 
  %% template_field_value_get/3,
  
  next_e/1,
  c/2,  
  c/3,
  c/4,
  c/5,  
  update/2,

  get_components/2, one_c/1, collect_c/1,  
  set_component/3,
  remove_component/2,

  add_template_components/3,
  remove_template_components/2,

  create_abil/3,
  create_unit/4,
  create_player/2,

  player_control_unit/2
  .

:- include('utils.pl').
:- include('systems.pl').
:- include('templates.pl').

ps :-
    current_chr_constraint(Module:Name),
    format('constraint store contains ~w:~w~n', [Module, Name]),
    fail.
ps.


%% /* Main */

%% ?- 


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




%% ?- next_e(1), create_abil(move, 0, AID).
%@ AID = 1,
%@ next_e(2),
%@ c(1,owner_id,0),
%@ c(1,cooldown,0),
%@ c(1,template,move),
%@ c(1,class,c_abil_move).

%% ?- next_e(0), create_unit(mage, 10, 20, UID).
%@ UID = 0,
%@ next_e(3),
%@ c(0,position,10-20),
%@ c(0,abils,[1,2]),
%@ c(2,owner_id,0),
%@ c(2,cooldown,0),
%@ c(2,template,morph_bear),
%@ c(2,class,c_abil_morph),
%@ c(1,owner_id,0),
%@ c(1,template,keyboard_move),
%@ c(1,class,c_abil_keyboard_move),
%@ c(0,speed,5),
%@ c(0,energy_max,100),
%@ c(0,energy,100),
%@ c(0,life_max,100),
%@ c(0,life,100),
%@ c(0,bounds,1),
%@ c(0,template,mage).

%% ?- next_e(0), create_unit(mage, 10, 20, UID), c(UID, event_c_unit_start_abil, morph_bear).
%@ UID = 0,
%@ next_e(4),
%@ c(2,cooldown,10),
%@ c(0,energy,0.0),
%@ c(0,life,500),
%@ c(0,abils,[3]),
%@ c(3,owner_id,0),
%@ c(3,cooldown,0),
%@ c(3,template,move),
%@ c(3,class,c_abil_move),
%@ c(0,speed,7),
%@ c(0,energy_max,0),
%@ c(0,life_max,500),
%@ c(0,bounds,2),
%@ c(0,template,bear),
%@ c(0,position,10-20),
%@ c(2,owner_id,0),
%@ c(2,template,morph_bear),
%@ c(2,class,c_abil_morph),
%@ c(1,owner_id,0),
%@ c(1,template,keyboard_move),
%@ c(1,class,c_abil_keyboard_move),
%@ c(0,template,mage).

%% ?- next_e(0), create_unit(mage, 10, 20, UID), set_component(UID, energy, 0), c(UID, event_c_unit_start_abil, morph_bear).
%@ UID = 0,
%@ next_e(3),
%@ c(0,energy,0),
%@ c(0,position,10-20),
%@ c(0,abils,[1,2]),
%@ c(2,owner_id,0),
%@ c(2,cooldown,0),
%@ c(2,template,morph_bear),
%@ c(2,class,c_abil_morph),
%@ c(1,owner_id,0),
%@ c(1,template,keyboard_move),
%@ c(1,class,c_abil_keyboard_move),
%@ c(0,speed,5),
%@ c(0,energy_max,100),
%@ c(0,life_max,100),
%@ c(0,life,100),
%@ c(0,bounds,1),
%@ c(0,template,mage).


%% ?- next_e(0), create_unit(mage_dup_abils, 10, 20, UID).
%@ UID = 0,
%@ next_e(4),
%@ c(0,position,10-20),
%@ c(0,abils,[1,2,3]),
%@ c(3,owner_id,0),
%@ c(3,cooldown,0),
%@ c(3,template,morph_bear),
%@ c(3,class,c_abil_morph),
%@ c(2,owner_id,0),
%@ c(2,cooldown,0),
%@ c(2,template,morph_bear),
%@ c(2,class,c_abil_morph),
%@ c(1,owner_id,0),
%@ c(1,template,keyboard_move),
%@ c(1,class,c_abil_keyboard_move),
%@ c(0,speed,5),
%@ c(0,energy_max,100),
%@ c(0,energy,100),
%@ c(0,life_max,100),
%@ c(0,life,100),
%@ c(0,bounds,1),
%@ c(0,template,mage_dup_abils).

%% ?- next_e(0), create_unit(mage_dup_abils, 10, 20, UID), c(UID, event_c_unit_start_abil, morph_bear).
%@ UID = 0,
%@ next_e(5),
%@ c(3,cooldown,10), % start abil 3
%@ c(0,energy,0.0),
%@ c(0,life,500),
%@ c(0,abils,[4]),
%@ c(4,owner_id,0),
%@ c(4,cooldown,0),
%@ c(4,template,move),
%@ c(4,class,c_abil_move),
%@ c(0,speed,7),
%@ c(0,energy_max,0),
%@ c(0,life_max,500),
%@ c(0,bounds,2),
%@ c(0,template,bear),
%@ c(0,position,10-20),
%@ c(3,owner_id,0),
%@ c(3,template,morph_bear),
%@ c(3,class,c_abil_morph),
%@ c(2,owner_id,0),
%@ c(2,cooldown,0),
%@ c(2,template,morph_bear),
%@ c(2,class,c_abil_morph),
%@ c(1,owner_id,0),
%@ c(1,template,keyboard_move),
%@ c(1,class,c_abil_keyboard_move),
%@ c(0,template,mage_dup_abils).

%% ?- next_e(0), create_unit(mage_dup_abils, 10, 20, UID), set_component(3, cooldown, 5), c(UID, event_c_unit_start_abil, morph_bear).
%@ UID = 0,
%@ next_e(5),
%@ c(2,cooldown,10), % start abil 2, because abil 3 cooldown is not ready
%@ c(0,energy,0.0),
%@ c(0,life,500),
%@ c(0,abils,[4]),
%@ c(4,owner_id,0),
%@ c(4,cooldown,0),
%@ c(4,template,move),
%@ c(4,class,c_abil_move),
%@ c(0,speed,7),
%@ c(0,energy_max,0),
%@ c(0,life_max,500),
%@ c(0,bounds,2),
%@ c(0,template,bear),
%@ c(3,cooldown,5),
%@ c(0,position,10-20),
%@ c(3,owner_id,0),
%@ c(3,template,morph_bear),
%@ c(3,class,c_abil_morph),
%@ c(2,owner_id,0),
%@ c(2,template,morph_bear),
%@ c(2,class,c_abil_morph),
%@ c(1,owner_id,0),
%@ c(1,template,keyboard_move),
%@ c(1,class,c_abil_keyboard_move),
%@ c(0,template,mage_dup_abils).

%% ?- next_e(0), create_unit(mage_dup_abils, 10, 20, UID), set_component(2, cooldown, 5), c(UID, event_c_unit_start_abil, morph_bear).
%@ UID = 0,
%@ next_e(5),
%@ c(3,cooldown,10),
%@ c(0,energy,0.0),
%@ c(0,life,500),
%@ c(0,abils,[4]),
%@ c(4,owner_id,0),
%@ c(4,cooldown,0),
%@ c(4,template,move),
%@ c(4,class,c_abil_move),
%@ c(0,speed,7),
%@ c(0,energy_max,0),
%@ c(0,life_max,500),
%@ c(0,bounds,2),
%@ c(0,template,bear),
%@ c(2,cooldown,5),
%@ c(0,position,10-20),
%@ c(3,owner_id,0),
%@ c(3,template,morph_bear),
%@ c(3,class,c_abil_morph),
%@ c(2,owner_id,0),
%@ c(2,template,morph_bear),
%@ c(2,class,c_abil_morph),
%@ c(1,owner_id,0),
%@ c(1,template,keyboard_move),
%@ c(1,class,c_abil_keyboard_move),
%@ c(0,template,mage_dup_abils).






%@ 000 
%@ false.

%@ false.


%@ UID = 0,
%@ next_e(3),
%@ c(2,event_c_abil_morph_execute),
%@ c(0,position,10-20),
%@ c(0,abils,[1,2]),
%@ c(2,owner_id,0),
%@ c(2,cooldown,0),
%@ c(2,template,morph_bear),
%@ c(2,class,c_abil_morph),
%@ c(1,owner_id,0),
%@ c(1,template,keyboard_move),
%@ c(1,class,c_abil_keyboard_move),
%@ c(0,speed,5),
%@ c(0,energy_max,100),
%@ c(0,energy,100),
%@ c(0,life_max,100),
%@ c(0,life,100),
%@ c(0,bounds,1),
%@ c(0,template,mage).


%@ false.
%@ false.
%@ UID = 0,
%@ next_e(3),
%@ c(2,event_c_abil_morph_execute),
%@ c(0,position,10-20),
%@ c(0,abils,[1,2]),
%@ c(2,owner_id,0),
%@ c(2,cooldown,0),
%@ c(2,template,morph_bear),
%@ c(2,class,c_abil_morph),
%@ c(1,owner_id,0),
%@ c(1,template,keyboard_move),
%@ c(1,class,c_abil_keyboard_move),
%@ c(0,speed,5),
%@ c(0,energy_max,100),
%@ c(0,energy,100),
%@ c(0,life_max,100),
%@ c(0,life,100),
%@ c(0,bounds,1),
%@ c(0,template,mage).








%% ?- next_e(0),
%%    create_unit(mage, 10, 20, EID0),
%%    create_unit(bear, 15, 30, EID1),
%%    create_unit(tree, 5, 5, EID2),
%%    create_unit(tree, 7, 7, EID3).
%@ EID0 = 0,
%@ EID1 = 3,
%@ EID2 = 5,
%@ EID3 = 6,
%@ next_e(7),
%@ c(6,position,7-7),
%@ c(6,abils,[]),
%@ c(6,speed,0),
%@ c(6,energy_max,0),
%@ c(6,energy,0),
%@ c(6,life_max,100),
%@ c(6,life,100),
%@ c(6,bounds,1),
%@ c(6,template,tree),
%@ c(5,position,5-5),
%@ c(5,abils,[]),
%@ c(5,speed,0),
%@ c(5,energy_max,0),
%@ c(5,energy,0),
%@ c(5,life_max,100),
%@ c(5,life,100),
%@ c(5,bounds,1),
%@ c(5,template,tree),
%@ c(3,position,15-30),
%@ c(3,abils,[4]),
%@ c(4,owner_id,3),
%@ c(4,cooldown_max,0),
%@ c(4,cooldown,0),
%@ c(4,template,move),
%@ c(4,class,c_abil_move),
%@ c(3,speed,7),
%@ c(3,energy_max,0),
%@ c(3,energy,0),
%@ c(3,life_max,500),
%@ c(3,life,500),
%@ c(3,bounds,2),
%@ c(3,template,bear),
%@ c(0,position,10-20),
%@ c(0,abils,[1,2]),
%@ c(2,owner_id,0),
%@ c(2,cooldown_max,10),
%@ c(2,cooldown,0),
%@ c(2,energy,50),
%@ c(2,template,morph_bear),
%@ c(2,class,c_abil_morph),
%@ c(1,owner_id,0),
%@ c(1,template,keyboard_move),
%@ c(1,class,c_abil_keyboard_move),
%@ c(0,speed,5),
%@ c(0,energy_max,100),
%@ c(0,energy,100),
%@ c(0,life_max,100),
%@ c(0,life,100),
%@ c(0,bounds,1),
%@ c(0,template,mage).
