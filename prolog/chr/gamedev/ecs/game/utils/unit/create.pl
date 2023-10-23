
c(T_EID, type, template) # passive,
c(T_EID, catalog, unit)  # passive,
c(T_EID, id, Tempalte)   # passive,
c(T_EID, class, Class)   # passive
\
create_unit(Template, X, Y, PlayerNo, EID)
<=>
  format("create_unit ~w ~w ~w ~w ~w~n", [Tempalte, X, Y, PlayerNo, EIDD]),
  create_e(EID),
  c(EID, type, unit),
  c(EID, template, Template),
  c(EID, position, pos(X,Y)),
  c(EID, player_no, PlayerNo),
  unit_on_create(Class, T_EID, EID),
  true.

create_unit(Tempalte, X, Y, PlayerNo, EID) <=> true.

%% -- dispatch --

c(T_EID, bounds,          Bounds        ) # passive,
c(T_EID, life_starting,   LifeStarting  ) # passive,
c(T_EID, life_max,        LifeMax       ) # passive,
c(T_EID, energy_starting, EnergyStarting) # passive,
c(T_EID, energy_max,      EnergyMax     ) # passive,
c(T_EID, speed,           Speed         ) # passive,
c(T_EID, abils,           Abils         ) # passive,
c(T_EID, weapons,         Weapons       ) # passive
\
unit_on_create(c_unit, T_EID, U_EID)
<=>
  format("unit_on_create c_unit~n"),
  c(U_EID, order_queue, []),  
  c(U_EID, bounds, Bounds),
  c(U_EID, life, LifeStarting),
  c(U_EID, life_max, LifeMax),
  c(U_EID, energy, EnergyStarting),
  c(U_EID, energy_max, EnergyMax),
  c(U_EID, speed, Speed),
  maplist({U_EID}/[A, AID]>>create_abil(A, U_EID, AID), Abils, AIDs),
  c(U_EID, abils, AIDs),
  maplist({U_EID}/[W, WID]>>create_weapon(W, U_EID, WID), Weapons, WIDs),
  c(U_EID, weapons, WIDs),
  true.