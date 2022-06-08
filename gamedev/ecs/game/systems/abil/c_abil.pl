%% common logic for every ability

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
