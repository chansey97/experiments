c(T_EID, type, template) # passive,
c(T_EID, catalog, unit) # passive,
c(T_EID, id, Tempalte) # passive
\
create_unit(Template, X, Y, PlayerNo, EID),
next_e(EID0) # passive
<=>
  EID=EID0,
  NextEID is EID0+1, next_e(NextEID),
  c(EID, type, unit),
  c(EID, template, Template),
  c(EID, position, X-Y),
  c(EID, player_no, PlayerNo),
  e(unit_init, T_EID, EID).

create_unit(Tempalte, X, Y, PlayerNo, EID) <=> true.


%% c(T_EID, class,           c_unit        ) # passive,
%% c(T_EID, bounds,          Bounds        ) # passive,
%% c(T_EID, life_starting,   LifeStarting  ) # passive,
%% c(T_EID, life_max,        LifeMax       ) # passive,
%% c(T_EID, energy_starting, EnergyStarting) # passive,
%% c(T_EID, energy_max,      EnergyMax     ) # passive,
%% c(T_EID, speed,           Speed         ) # passive,
%% c(T_EID, abils,           Abils         ) # passive,
%% c(T_EID, weapons,         Weapons       ) # passive
%% \
%% e(unit_init, T_EID, U_EID)
%% <=>
%%   c(U_EID, order_queue, []),  
%%   c(U_EID, bounds, Bounds),
%%   c(U_EID, life, LifeStarting),
%%   c(U_EID, life_max, LifeMax),
%%   c(U_EID, energy, EnergyStarting),
%%   c(U_EID, energy_max, EnergyMax),
%%   c(U_EID, speed, Speed),
%%   % abils  
%%   maplist({U_EID}/[A, AID]>>create_abil(A, U_EID, AID), Abils, AIDs),
%%   c(U_EID, abils, AIDs),
%%   %% weapons
%%   maplist({U_EID}/[W, WID]>>create_weapon(W, U_EID, WID), Weapons, WIDs),
%%   c(U_EID, weapons, WIDs).
