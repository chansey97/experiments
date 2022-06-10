
%% abil_init
c(C_EID, type, class)             # passive,
c(C_EID, id, c_abil)              # passive
\
e(abil_init, C_EID, T_EID, A_EID)
<=>
  %% format("c_abil abil_init~n"),
  true.

%% abil_fini
c(C_EID, type, class)             # passive,
c(C_EID, id, c_abil)              # passive
\
e(abil_fini, C_EID, T_EID, A_EID)
<=>
  format("c_abil abil_fini~n"),  
  true.


%% %% on check
%% c_abil_check @
%% c(AID, event_abil_check, c_abil)
%% <=>  
%%   true.

%% c_abil_check @
%% c(AID, event_abil_check, c_abil) <=> false.

%% %% on execute
%% c_abil_execute @
%% c(AID, event_abil_execute, c_abil)
%% <=>
%%   true.

%% c_abil_execute @
%% c(AID, event_abil_check, c_abil) <=> true.
