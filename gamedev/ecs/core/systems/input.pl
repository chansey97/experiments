%% TODO: Does c(UID, abil_start, abil_morph, morph_into_bear, _) is a component? or event?
%% input_system @ update(input, FID), c(_, player_control, UID) #passive ==>
%%   current_input(IO),
%%   read_string(IO, 2, S),
%%   format("update(input, FID=~w) ", [FID]),
%%   (   S="a\n"
%%       %% TODO: c/5 can be used for trigger
%%   ->  c(UID, abil_start, abil_morph, morph_into_bear, _) % assuming morph is a instant ability, so no cast system update needed
%%   ;   true   
%%   ).
%% input_system @ update(input, FID) <=> true.