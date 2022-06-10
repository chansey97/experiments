%% TODO: Ideally All the reference in class, template and entity, should sue EID instead of name.

%% create_abil
c(T_EID, type, template)             # passive,
c(T_EID, catalog, abil)              # passive,
c(T_EID, id, Tempalte)               # passive,
c(T_EID, class, Class)               # passive, % TODO: It is better c(T_EID, class, Class) is c(T_EID, class_eid, C_EID)
c(C_EID, type, class)                # passive,
c(C_EID, id, Class)                  # passive
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
  %% TODO: Is just e(abil_init, Class, Template, EID) is enough?
  e(abil_init, C_EID, T_EID, EID),
  true.

create_abil(Tempalte, OwnerID, EID) <=> true.

%% destroy_abil
c(A_EID, type, abil)         # passive,
c(A_EID, template, Tempalte) # passive,
c(T_EID, type, template)     # passive,
c(T_EID, catalog, abil)      # passive,
c(T_EID, id, Tempalte)       # passive,
c(T_EID, class, Class)       # passive,
c(C_EID, type, class)        # passive,
c(C_EID, id, Class)          # passive
\
destroy_abil(A_EID)
<=>
  format("destroy_abil ~w ~n", [A_EID]),    
  e(abil_fini, C_EID, T_EID, A_EID),
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