
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



%% %% on start abil

%% %% abil's workflow:
%% %% event_unit_start_abil with c_abil_morph
%% %% -> event_abil_morph_check -> event_abil_check
%% %% -> event_abil_morph_execute

%% %% event_unit_start_abil with c_abil_effect_instant
%% %% -> event_abil_effect_instant_check -> event_abil_effect_check -> event_abil_check
%% %% -> event_abil_effect_instant_execute

%% %% TODO:
%% %% If a abil requrie a target, the target_id will be a component already attached in abil entity

%% c_unit_issue_order @
%% c(UID, type, unit) # passive,
%% c(UID, abils, AIDs) # passive,
%% c(AID, type, abil) # passive,
%% c(AID, template, AbilTemplate) # passive
%% \
%% c(UID, next_order_abil, AbilTemplate) # passive,
%% c(UID, next_order_abil_target, AbilTarget) # passive,
%% c(UID, event_unit_issue_order, c_unit)
%% <=>
%%   memberchk(AID, AIDs),
%%   abil_check(AID, AbilTarget)
%%   |
%%   abil_execute(AID, AbilTarget).

%% %% c_unit_issue_order_cleanup @
%% %% c(UID, next_order_abil, AbilTemplate) # passive,
%% %% c(UID, next_order_abil_target, AbilTarget) # passive,
%% %% c(UID, event_unit_issue_order, c_unit)
%% %% <=>
%% %%   true.




