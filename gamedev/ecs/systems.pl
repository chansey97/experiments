
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


