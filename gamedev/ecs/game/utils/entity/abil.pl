
%% I currently decide to not treat class as an entity and no C_EID.
%% N.B.
%% If class also an entity, then template should use C_EID instead of class name,
%% then someone would say that all templates' occurrences should use T_EID and so on.
%% This would make database very unreadable and not easy for prototype development.

%% create_abil
c(T_EID, type, template)             # passive,
c(T_EID, catalog, abil)              # passive,
c(T_EID, id, Tempalte)               # passive,
c(T_EID, class, Class)               # passive
\
create_abil(Tempalte, OwnerID, EID)           ,
next_e(EID0)                         # passive
<=>
  format("create_abil ~w ~w ~w ~n", [Tempalte, OwnerID, EID]),  
  EID=EID0,
  NextEID is EID0+1, next_e(NextEID),   
  c(EID, type, abil),
  c(EID, template, Tempalte),  
  c(EID, owner_id, OwnerID),
  %% abil_init(Class, T_EID, EID),
  e(abil_init, Class, T_EID, A_EID),
  true.

create_abil(Tempalte, OwnerID, EID) <=> true.

%% destroy_abil
c(A_EID, type, abil)         # passive,
c(A_EID, template, Tempalte) # passive,
c(T_EID, type, template)     # passive,
c(T_EID, catalog, abil)      # passive,
c(T_EID, id, Tempalte)       # passive,
c(T_EID, class, Class)       # passive
\
destroy_abil(A_EID)
<=>
  format("destroy_abil ~w ~n", [A_EID]),    
  e(abil_fini, Class, T_EID, A_EID),
  remove_component(A_EID, type),
  remove_component(A_EID, template),
  remove_component(A_EID, owner_id),  
  true.

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