
%% Order is
%% order(AbilTempalte, AbilTarget)

%% AbilTarget can be
%% target(point, Point), this is kind of location
%% target(unit, UnitID),
%% no_target

%% AbilSource can be
%% source(player, PlayerID)
%% source(unit, UnitID)


c(U_EID, type, unit)         # passive, % TODO: check alive
c(U_EID, template, Tempalte) # passive,
c(T_EID, type, template)     # passive,
c(T_EID, catalog, unit)      # passive,
c(T_EID, id, Tempalte)       # passive,
c(T_EID, class, Class)       # passive
\
unit_issue_order(U_EID, Order)
<=>
  %% c(U_EID, next_order_abil, AbilTemplate),
  %% c(U_EID, next_order_abil_target, AbilTarget), 
  %% c(U_EID, event_unit_issue_order, c_unit),
  format("unit_issue_order ~w ~w ~n", [U_EID, Order]),
  unit_on_issue_order(c_unit, T_EID, U_EID, Order),
  true .

unit_issue_order(U_EID, Order) <=> true.

%% -- dispatch --

c(U_EID, abils, A_EIDs) # passive,
c(A_EID, type, abil) # passive,
c(A_EID, template, AbilTemplate) # passive
\
unit_on_issue_order(c_unit, T_EID, U_EID, order(AbilTemplate, AbilTarget))
<=>
  memberchk(A_EID, A_EIDs),
  abil_check(A_EID, AbilTarget)
  |
  format("unit_on_issue_order c_unit~n"),
  abil_execute(A_EID, AbilTarget),  
  true.

unit_on_issue_order(c_unit, _, _, _) <=> true.



