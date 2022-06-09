%% An ECS(Entity Component System) simulation via Constraint Handling Rules.
:- use_module(library(chr)).
:- use_module(library(yall)).

:- debug.

:- set_prolog_flag(chr_toplevel_show_store, false).

:- chr_constraint

  %% TODO: template also use CHR
  %% template_class_get/4, 
  %% template_parent_get/4, 
  %% template_field_value_get/4,
  
  next_e/1,
  %% get_next_e/1,  
  c/2,  
  c/3,
  c/4,
  c/5,
  e/1,
  e/2,
  e/3,
  e/4,  
  update/2,

  get_components/2, one_c/1, collect_c/1,  
  set_component/3,
  remove_component/2,
  %% check_component/3,
  get_component/3,

  %% create_template/2,
  create_template/4,
  
  create_unit/5,
  destroy_unit/1,
  replace_unit_template/2,
  unit_issue_order/2,
  
  create_abil/3,
  destroy_abil/1,
  abil_check/2,
  abil_execute/2,
  abil_cancel/1,  
  
  create_weapon/3,
  destroy_weapon/1,
  
  create_effect/4,
  destroy_effect/1,

  %% no need point entity, because it is just a editor preset
  %% in runtime, it is a point record  
  %% create_point/3,
  %% destroy_point/1,
  
  create_player/2,
  destroy_player/1,  
  player_control_unit/2
  .
:- dynamic raw_template/4, raw_template_field/4.

%% Classes
:- include("./game/classes/abil.pl").
:- include("./game/classes/actor.pl").
:- include("./game/classes/behavior.pl").
:- include("./game/classes/effect.pl").
:- include("./game/classes/unit.pl").
:- include("./game/classes/weapon.pl").

%% Utils
:- include("./game/utils/misc.pl").
:- include("./game/utils/chr.pl").
:- include("./game/utils/component.pl").
:- include("./game/utils/class.pl").
:- include("./game/utils/raw_template.pl").

:- include("./game/utils/entity/template.pl").
:- include("./game/utils/entity/abil.pl").
:- include("./game/utils/entity/effect.pl").
:- include("./game/utils/entity/player.pl").
:- include("./game/utils/entity/unit.pl").
:- include("./game/utils/entity/weapon.pl").

%% Systems
%% :- include("./game/systems/input.pl").

%% :- include("./game/systems/unit/c_unit.pl").

%% :- include("./game/systems/abil/c_abil.pl").
%% :- include("./game/systems/abil/c_abil_attack.pl").
%% :- include("./game/systems/abil/c_abil_effect.pl").
%% :- include("./game/systems/abil/c_abil_effect_instant.pl").
%% :- include("./game/systems/abil/c_abil_effect_target.pl").
%% :- include("./game/systems/abil/c_abil_keyboard_move.pl").
%% :- include("./game/systems/abil/c_abil_morph.pl").
:- include("./game/systems/abil/c_abil_move.pl").

%% :- include("./game/systems/weapon/c_weapon_legacy.pl").

%% :- include("./game/systems/effect/c_effect_damage.pl").
%% :- include("./game/systems/effect/c_effect_launch_missile.pl").
%% :- include("./game/systems/effect/c_effect_modify_unit.pl").

%% :- include("./game/systems/behavior/c_behavior_attribute.pl").
%% :- include("./game/systems/behavior/c_behavior_buff.pl").

%% :- include("./game/systems/mover/c_mover.pl").
%% :- include("./game/systems/mover/c_mover_avoid.pl").

%% :- include("./game/systems/actor/c_actor.pl").

%% :- include("./game/systems/render.pl").

init :-
  load_raw_templates("./map/templates"),
  next_e(10).

%% ?- init, listing(raw_template), listing(raw_template_field).        

%% ?- init, load_templates, chr_listing(_).

%% ?- init,
%%    load_templates,
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, template), Group))).
%@ print_entities_when: 
%@ true.

%% TODO: Regression Testing

%% /* Tests */

%% ?- init, load_templates,
%%    create_abil(move, 0, AID),
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, template), Group))),
%%    destroy_abil(AID),
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, template), Group))).
%@ print_entities_when
%@ print_entity
%@  c(35,cooldown,0)
%@  c(35,owner_id,0)
%@  c(35,template,move)
%@  c(35,type,abil)
%@ print_entities_when
%@ AID = 35.

%% ---


%% ?- init, load_templates,
%%    create_weapon(bear_claws, 0, AID),
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, template), Group))).
%@ AID = 1,
%@ next_e(2),
%@ c(1,time_point,0),
%@ c(1,owner_id,0),
%@ c(1,template,bear_claws),
%@ c(1,class,c_weapon_legacy),
%@ c(1,type,weapon).

%% ?- next_e(1), create_effect(bear_claws_damage, 0, 0, EID).
%@ EID = 1,
%@ next_e(2).

%% ?- next_e(0),
%%    create_player(1, PID),
%%    create_unit(mage, 10, 20, 1, UID).
%@ PID = 0,
%@ UID = 1,
%@ next_e(5),
%@ c(1,weapons,[]),
%@ c(1,abils,[2,3,4]),
%@ c(4,cooldown,0),
%@ c(4,owner_id,1),
%@ c(4,template,self_heal),
%@ c(4,class,c_abil_effect_instant),
%@ c(4,type,abil),
%@ c(3,cooldown,0),
%@ c(3,owner_id,1),
%@ c(3,template,morph_bear),
%@ c(3,class,c_abil_morph),
%@ c(3,type,abil),
%@ c(2,owner_id,1),
%@ c(2,template,keyboard_move),
%@ c(2,class,c_abil_keyboard_move),
%@ c(2,type,abil),
%@ c(1,speed,5),
%@ c(1,energy_max,100),
%@ c(1,energy,100),
%@ c(1,life_max,100),
%@ c(1,life,100),
%@ c(1,bounds,1),
%@ c(1,player_no,1),
%@ c(1,position,10-20),
%@ c(1,template,mage),
%@ c(1,class,c_unit),
%@ c(1,type,unit),
%@ c(0,player_no,1),
%@ c(0,type,player).


%% ?- next_e(0),
%%    create_player(1, PID),
%%    create_unit(mage, 10, 20, 1, UID),
%%    c(UID, event_unit_start_abil, c_unit, morph_bear).
%@ PID = 0,
%@ UID = 1,
%@ next_e(8),
%@ c(1,energy,0.0),
%@ c(1,life,500),
%@ c(1,weapons,[7]),
%@ c(7,time_point,0),
%@ c(7,owner_id,1),
%@ c(7,template,bear_claws),
%@ c(7,class,c_weapon_legacy),
%@ c(7,type,weapon),
%@ c(1,abils,[5,6]),
%@ c(6,cooldown,0),
%@ c(6,owner_id,1),
%@ c(6,template,attack),
%@ c(6,class,c_abil_attack),
%@ c(6,type,abil),
%@ c(5,cooldown,0),
%@ c(5,owner_id,1),
%@ c(5,template,move),
%@ c(5,class,c_abil_move),
%@ c(5,type,abil),
%@ c(1,speed,7),
%@ c(1,energy_max,0),
%@ c(1,life_max,500),
%@ c(1,bounds,2),
%@ c(1,template,bear),
%@ c(1,player_no,1),
%@ c(1,position,10-20),
%@ c(1,class,c_unit),
%@ c(1,type,unit),
%@ c(0,player_no,1),
%@ c(0,type,player).

%% ?- next_e(0),
%%    create_player(1, PID),
%%    create_unit(mage, 10, 20, 1, UID),
%%    set_component(UID, energy, 0),
%%    c(UID, event_unit_start_abil, c_unit, morph_bear).
%@ PID = 0,
%@ UID = 1,
%@ next_e(5),
%@ c(1,energy,0),
%@ c(1,weapons,[]),
%@ c(1,abils,[2,3,4]),
%@ c(4,cooldown,0),
%@ c(4,owner_id,1),
%@ c(4,template,self_heal),
%@ c(4,class,c_abil_effect_instant),
%@ c(4,type,abil),
%@ c(3,cooldown,0),
%@ c(3,owner_id,1),
%@ c(3,template,morph_bear),
%@ c(3,class,c_abil_morph),
%@ c(3,type,abil),
%@ c(2,owner_id,1),
%@ c(2,template,keyboard_move),
%@ c(2,class,c_abil_keyboard_move),
%@ c(2,type,abil),
%@ c(1,speed,5),
%@ c(1,energy_max,100),
%@ c(1,life_max,100),
%@ c(1,life,100),
%@ c(1,bounds,1),
%@ c(1,player_no,1),
%@ c(1,position,10-20),
%@ c(1,template,mage),
%@ c(1,class,c_unit),
%@ c(1,type,unit),
%@ c(0,player_no,1),
%@ c(0,type,player).

%% ?- next_e(0),
%%    create_player(1, PID),
%%    create_unit(mage, 10, 20, 1, UID),
%%    set_component(UID, life, 10),
%%    c(UID, event_unit_start_abil, c_unit, self_heal).
%@ PID = 0,
%@ UID = 1,
%@ next_e(6),
%@ c(4,cooldown,10),
%@ c(1,energy,50),
%@ c(1,life,100),
%@ c(1,weapons,[]),
%@ c(1,abils,[2,3,4]),
%@ c(4,owner_id,1),
%@ c(4,template,self_heal),
%@ c(4,class,c_abil_effect_instant),
%@ c(4,type,abil),
%@ c(3,cooldown,0),
%@ c(3,owner_id,1),
%@ c(3,template,morph_bear),
%@ c(3,class,c_abil_morph),
%@ c(3,type,abil),
%@ c(2,owner_id,1),
%@ c(2,template,keyboard_move),
%@ c(2,class,c_abil_keyboard_move),
%@ c(2,type,abil),
%@ c(1,speed,5),
%@ c(1,energy_max,100),
%@ c(1,life_max,100),
%@ c(1,bounds,1),
%@ c(1,player_no,1),
%@ c(1,position,10-20),
%@ c(1,template,mage),
%@ c(1,class,c_unit),
%@ c(1,type,unit),
%@ c(0,player_no,1),
%@ c(0,type,player).


%% duplicate ability, 4 and 5,
%% if abil 4 cooldown is not ready, use 5

%% ?- next_e(0),
%%    create_player(1, PID),
%%    create_unit(mage_dup_abils, 10, 20, 1, UID),
%%    set_component(UID, life, 10),
%%    set_component(4, cooldown, 5),
%%    c(UID, event_unit_start_abil, c_unit, self_heal).
%@ PID = 0,
%@ UID = 1,
%@ next_e(7),
%@ c(5,cooldown,10),
%@ c(1,energy,50),
%@ c(1,life,100),
%@ c(4,cooldown,5),
%@ c(1,weapons,[]),
%@ c(1,abils,[2,3,4,5]),
%@ c(5,owner_id,1),
%@ c(5,template,self_heal),
%@ c(5,class,c_abil_effect_instant),
%@ c(5,type,abil),
%@ c(4,owner_id,1),
%@ c(4,template,self_heal),
%@ c(4,class,c_abil_effect_instant),
%@ c(4,type,abil),
%@ c(3,cooldown,0),
%@ c(3,owner_id,1),
%@ c(3,template,morph_bear),
%@ c(3,class,c_abil_morph),
%@ c(3,type,abil),
%@ c(2,owner_id,1),
%@ c(2,template,keyboard_move),
%@ c(2,class,c_abil_keyboard_move),
%@ c(2,type,abil),
%@ c(1,speed,5),
%@ c(1,energy_max,100),
%@ c(1,life_max,100),
%@ c(1,bounds,1),
%@ c(1,player_no,1),
%@ c(1,position,10-20),
%@ c(1,template,mage_dup_abils),
%@ c(1,class,c_unit),
%@ c(1,type,unit),
%@ c(0,player_no,1),
%@ c(0,type,player).

%% duplicate ability, 4 and 5,
%% if abil 5 cooldown is not ready, use 4

%% ?- next_e(0),
%%    create_player(1, PID),
%%    create_unit(mage_dup_abils, 10, 20, 1, UID),
%%    set_component(UID, life, 10),
%%    set_component(5, cooldown, 5),
%%    c(UID, event_unit_start_abil, c_unit, self_heal).
%@ PID = 0,
%@ UID = 1,
%@ next_e(7),
%@ c(4,cooldown,10),
%@ c(1,energy,50),
%@ c(1,life,100),
%@ c(5,cooldown,5),
%@ c(1,weapons,[]),
%@ c(1,abils,[2,3,4,5]),
%@ c(5,owner_id,1),
%@ c(5,template,self_heal),
%@ c(5,class,c_abil_effect_instant),
%@ c(5,type,abil),
%@ c(4,owner_id,1),
%@ c(4,template,self_heal),
%@ c(4,class,c_abil_effect_instant),
%@ c(4,type,abil),
%@ c(3,cooldown,0),
%@ c(3,owner_id,1),
%@ c(3,template,morph_bear),
%@ c(3,class,c_abil_morph),
%@ c(3,type,abil),
%@ c(2,owner_id,1),
%@ c(2,template,keyboard_move),
%@ c(2,class,c_abil_keyboard_move),
%@ c(2,type,abil),
%@ c(1,speed,5),
%@ c(1,energy_max,100),
%@ c(1,life_max,100),
%@ c(1,bounds,1),
%@ c(1,player_no,1),
%@ c(1,position,10-20),
%@ c(1,template,mage_dup_abils),
%@ c(1,class,c_unit),
%@ c(1,type,unit),
%@ c(0,player_no,1),
%@ c(0,type,player).




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
