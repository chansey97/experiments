create_unit @
create_unit(Template, X, Y, PlayerNo, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  template_field_value_get(unit, Template, class, Class),
  c(EID, type, unit),
  c(EID, class, Class),
  c(EID, template, Template),
  c(EID, position, X-Y),
  c(EID, player_no, PlayerNo),
  c(EID, event_unit_create, Class).

destory_unit @
c(EID, type, unit) # passive,
c(EID, class, Class) # passive
\
destroy_unit(EID)
<=>
  c(EID, event_unit_destroy, Class),
  remove_component(EID, type),
  remove_component(EID, class),
  remove_component(EID, template),
  remove_component(EID, position),
  remove_component(EID, player_no).

%% TODO: kill_unit, etc.

unit_replace_template @
c(EID, type, unit) # passive,
c(EID, class, Class) # passive
\
replace_unit_template(EID, Template)
<=>
  c(EID, event_unit_replace_template, Class, Template).


%% target of order can be
%% target(point, Point), target(unit, UnitID), no_target
unit_issue_order @
c(UID, type, unit) # passive % TODO: check alive
\
unit_issue_order(UID, order(AbilTemplate, AbilTarget))
<=>
  c(UID, next_order_abil, AbilTemplate),
  c(UID, next_order_abil_target, AbilTarget), 
  c(UID, event_unit_issue_order, c_unit)

  %% TODO:
  %% Two options for event component:
  %% 1. (Currently)remove event in the event handle system
  %% 2. remove event in the event posteradd event sender? advangtage is event handle can see all the events and have no to remove them 
  %% CHR is too powerful, a rule can see constraints on call stack!
  
  %% remove_component(UID, next_order_abil),
  %% remove_component(UID, next_order_abil_target),
  %% remove_component(UID, next_order_abil_target),  
  .





