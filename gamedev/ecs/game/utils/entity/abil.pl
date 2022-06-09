
%% create_abil
c(T_EID, type, template) # passive,
c(T_EID, catalog, abil) # passive,
c(T_EID, id, Tempalte) # passive
\
create_abil(Tempalte, OwnerID, EID),
next_e(EID0) # passive
<=>
  EID=EID0,
  NextEID is EID0+1, next_e(NextEID),
  c(EID, type, abil),
  c(EID, template, Tempalte),  
  c(EID, owner_id, OwnerID),
  e(abil_init, T_EID, EID).

create_abil(Tempalte, OwnerID, EID) <=> true.

%% destroy_abil
c(A_EID, type, abil) # passive,
c(A_EID, template, Tempalte) # passive,
c(T_EID, type, template) # passive,
c(T_EID, catalog, abil) # passive,
c(T_EID, id, Tempalte) # passive
\
destroy_abil(A_EID)
<=>
  e(abil_fini, T_EID, A_EID),
  remove_component(A_EID, type),
  remove_component(A_EID, template),
  remove_component(A_EID, owner_id).

destroy_abil(A_EID) <=> true.


%% abil_check @
%% c(AID, type, abil) # passive,
%% c(AID, class, Class) # passive
%% \
%% abil_check(AID, AbilTarget)
%% <=>
%%   c(AID, abil_target, AbilTarget),
%%   c(AID, event_abil_check, Class).

%% abil_execute @
%% c(AID, type, abil) # passive,
%% c(AID, class, Class) # passive
%% \
%% abil_execute(AID, AbilTarget)
%% <=>
%%   c(AID, abil_target, AbilTarget),
%%   c(AID, event_abil_execute, Class).

%% abil_cancel @
%% c(AID, type, abil) # passive,
%% c(AID, class, Class) # passive
%% \
%% abil_cancel(AID)
%% <=>
%%   c(AID, event_abil_cancel, Class).