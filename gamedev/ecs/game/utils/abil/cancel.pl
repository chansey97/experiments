%% abil_cancel @
%% c(AID, type, abil) # passive,
%% c(AID, class, Class) # passive
%% \
%% abil_cancel(AID)
%% <=>
%%   c(AID, event_abil_cancel, Class).


%% c_abil_effect_cancel @
%% c(AID, type, abil) #passive,
%% c(AID, owner_id, UID) # passive,
%% c(UID, type, unit) #passive,
%% \
%% c(UID, executing_abil, AID) #passive,
%% c(AID, event_abil_cancel, c_abil_effect)
%% <=>
%%   true.

%% c_abil_effect_cancel_cleanup @
%% c(AID, event_abil_cancel, c_abil_effect) <=> true.

%% c_abil_effect_instant:event_abil_cancel @
%% c(AID, template, Template) # passive,
%% \  
%% c(AID, event_abil_cancel, c_abil_effect_instant)
%% <=>
%%   sub_class(c_abil_effect_instant, SuperClass),
%%   c(AID, event_abil_cancel, SuperClass).

%% c(AID, event_abil_cancel, c_abil_effect_instant) <=> true.

%% c(AID, template, Template) # passive,
%% \  
%% c(AID, event_abil_cancel, c_abil_effect_target)
%% <=>
%%   sub_class(c_abil_effect_target, SuperClass),
%%   c(AID, event_abil_cancel, SuperClass).

%% c(AID, event_abil_cancel, c_abil_effect_target) <=> true.