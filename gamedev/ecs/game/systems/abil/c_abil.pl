
%% %% abil_init
%% c(T_EID, class, c_abil_move) # passive
%% \
%% e(abil_init, T_EID, A_EID)
%% <=>
%%   c(A_EID, cooldown, 0).

%% %% abil_fini
%% c(T_EID, class, c_abil_move) # passive
%% \
%% e(abil_fini, T_EID, A_EID)
%% <=>
%%   remove_component(A_EID, cooldown).

%% TODO: 
%% How c_abil_move call super class method c_abil?
%% Now c_abil_move depends on template now class, so we may need e(abil_init, T_EID, A_EID, SuperClass)
%% But this approach is not consistent.

%% It is better to have class entity, then we can consistently call e(abil_init, C_EID, T_EID, A_EID)
%% That would be nice.


%% on check
c_abil_check @
c(AID, event_abil_check, c_abil)
<=>  
  true.

c_abil_check @
c(AID, event_abil_check, c_abil) <=> false.

%% on execute
c_abil_execute @
c(AID, event_abil_execute, c_abil)
<=>
  true.

c_abil_execute @
c(AID, event_abil_check, c_abil) <=> true.
