
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


c(U_EID, type, unit) # passive,
c(U_EID, template, Tempalte) # passive,
c(T_EID, type, template) # passive,
c(T_EID, catalog, unit) # passive,
c(T_EID, id, Tempalte) # passive
\
destroy_unit(U_EID)
<=>
  e(unit_fini, T_EID, U_EID),
  remove_component(U_EID, type),
  remove_component(U_EID, template),
  remove_component(U_EID, position),
  remove_component(U_EID, player_no).

destroy_unit(U_EID) <=> true.

%% %% TODO: kill_unit, etc.

%% unit_replace_template @
%% c(EID, type, unit) # passive,
%% c(EID, class, Class) # passive
%% \
%% replace_unit_template(EID, Template)
%% <=>
%%   c(EID, event_unit_replace_template, Class, Template).


%% %% target of order can be
%% %% target(point, Point), target(unit, UnitID), no_target
%% unit_issue_order @
%% c(UID, type, unit) # passive % TODO: check alive
%% \
%% unit_issue_order(UID, order(AbilTemplate, AbilTarget))
%% <=>
%%   c(UID, next_order_abil, AbilTemplate),
%%   c(UID, next_order_abil_target, AbilTarget), 
%%   c(UID, event_unit_issue_order, c_unit)

%%   %% TODO:
%%   %% Two options for event component:
%%   %% 1. (Currently)remove event in the event handle system
%%   %% 2. remove event in the event posteradd event sender? advangtage is event handle can see all the events and have no to remove them 
%%   %% CHR is too powerful, a rule can see constraints on call stack!
  
%%   %% remove_component(UID, next_order_abil),
%%   %% remove_component(UID, next_order_abil_target),
%%   %% remove_component(UID, next_order_abil_target),  
%%   .





