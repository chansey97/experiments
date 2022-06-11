
%% abil_init
e(abil_init, c_abil, T_EID, A_EID)
<=>
  format("c_abil abil_init~n"),
  true.

%% abil_fini
e(abil_fini, c_abil, T_EID, A_EID)
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
