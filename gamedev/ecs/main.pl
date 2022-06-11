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
  e/3,
  e/4,  
  update/2,

  get_components/2, one_c/1, collect_c/1,  
  set_component/3,
  remove_component/2,
  %% check_component/3,
  get_component/3,

  create_class/3,
  
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

:- include("./game/utils/template.pl").
:- include("./game/utils/player.pl").

:- include("./game/utils/unit/create.pl").
:- include("./game/utils/unit/destroy.pl").
:- include("./game/utils/unit/issue_order.pl").
:- include("./game/utils/unit/replace_template.pl").

:- include("./game/utils/abil/create.pl").
:- include("./game/utils/abil/destroy.pl").
:- include("./game/utils/abil/check.pl").
:- include("./game/utils/abil/execute.pl").
:- include("./game/utils/abil/cancel.pl").

:- include("./game/utils/weapon/create.pl").
:- include("./game/utils/weapon/destroy.pl").

:- include("./game/utils/effect/create.pl").
:- include("./game/utils/effect/destroy.pl").
:- include("./game/utils/effect/start.pl").


%% Systems
%% :- include("./game/systems/input.pl").

:- include("./game/systems/unit/ai.pl").
:- include("./game/systems/unit/missile.pl").

:- include("./game/systems/abil/staging.pl").

:- include("./game/systems/weapon/staging.pl").

:- include("./game/systems/effect/persistent.pl").

:- include("./game/systems/mover/standard.pl").
:- include("./game/systems/mover/flock.pl").

:- include("./game/systems/actor/event.pl").

%% :- include("./game/systems/render.pl").


init :-
  load_raw_templates("./map/templates"),
  next_e(10),

  load_templates.

%% ?- load_raw_templates("./map/templates"),
%%    listing(raw_template),
%%    listing(raw_template_field).

%% ?- init, chr_listing(_).

%% ?- init,
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, class), Group) ,
%%                                       \+ member(c(_, type, template), Group))).
%@ > print_entities_when
%@ true.


%% TODO: Regression Testing

%% /* Tests */

%% ?- init,
%%    create_abil(move, 0, A_EID),
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, class), Group) ,
%%                                       \+ member(c(_, type, template), Group))),
%%    destroy_abil(A_EID),
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, class), Group) ,
%%                                       \+ member(c(_, type, template), Group))).
%@ create_abil move 0 _86494 
%@ c_abil_move abil_init
%@ c_abil abil_init
%@ > print_entities_when
%@ > > print_entity
%@     c(36,cooldown,0)
%@     c(36,owner_id,0)
%@     c(36,template,move)
%@     c(36,type,abil)
%@ destroy_abil 36 
%@ c_abil_move abil_fini
%@ c_abil abil_fini
%@ > print_entities_when
%@ A_EID = 36.


%% ?- init,
%%    create_weapon(bear_claws, 0, W_EID),
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, class), Group) ,
%%                                       \+ member(c(_, type, template), Group))),
%%    destroy_weapon(W_EID),
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, class), Group) ,
%%                                       \+ member(c(_, type, template), Group))).
%@ > print_entities_when
%@ > > print_entity
%@     c(36,time_point,0)
%@     c(36,cooldown,0)
%@     c(36,owner_id,0)
%@     c(36,template,bear_claws)
%@     c(36,type,weapon)
%@ > print_entities_when
%@ W_EID = 36.

%% ?- init,
%%    create_effect(bear_claws_damage, 0, 0, E_EID),
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, class), Group) ,
%%                                       \+ member(c(_, type, template), Group))).
%@ > print_entities_when
%@ > > print_entity
%@     c(36,target_id,0)
%@     c(36,caster_id,0)
%@     c(36,template,bear_claws_damage)
%@     c(36,type,effect)
%@ E_EID = 36.


%% ?- init,
%%    create_player(1, P_EID),
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, class), Group) ,
%%                                       \+ member(c(_, type, template), Group))),
%%    destroy_player(P_EID),
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, class), Group) ,
%%                                       \+ member(c(_, type, template), Group))).
%@ > print_entities_when
%@ > > print_entity
%@     c(36,player_no,1)
%@     c(36,type,player)
%@ > print_entities_when
%@ P_EID = 36.


%% ?- init,
%%    create_player(1, P_EID),
%%    create_unit(test_unit, 10, 20, 1, U_EID),
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, class), Group) ,
%%                                       \+ member(c(_, type, template), Group))),
%%    destroy_unit(U_EID),
%%    print_entities_when([EID, Group]>>(\+ member(c(_, type, class), Group) ,
%%                                       \+ member(c(_, type, template), Group))).
%@ create_abil move 37 _158860 
%@ c_abil_move abil_init
%@ c_abil abil_init
%@ > print_entities_when
%@ > > print_entity
%@     c(37,weapons,[39])
%@     c(37,abils,[38])
%@     c(37,cooldown,0)
%@     c(37,speed,7)
%@     c(37,energy_max,0)
%@     c(37,energy,0)
%@     c(37,life_max,500)
%@     c(37,life,500)
%@     c(37,bounds,2)
%@     c(37,order_queue,[])
%@     c(37,player_no,1)
%@     c(37,position,10-20)
%@     c(37,template,test_unit)
%@     c(37,type,unit)
%@ > > print_entity
%@     c(39,time_point,0)
%@     c(39,cooldown,0)
%@     c(39,owner_id,37)
%@     c(39,template,bear_claws)
%@     c(39,type,weapon)
%@     c(39,cooldown,0)
%@ > > print_entity
%@     c(38,cooldown,0)
%@     c(38,owner_id,37)
%@     c(38,template,move)
%@     c(38,type,abil)
%@ > > print_entity
%@     c(36,cooldown,0)
%@     c(36,player_no,1)
%@     c(36,type,player)
%@ destroy_abil 38 
%@ c_abil_move abil_fini
%@ c_abil abil_fini
%@ > print_entities_when
%@ > > print_entity
%@     c(36,cooldown,0)
%@     c(36,player_no,1)
%@     c(36,type,player)
%@ P_EID = 36,
%@ U_EID = 37.

%% ----- I founda problem, currently it is not easy to call super  -----

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
