create_player @
create_player(PlayerNo, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  c(EID, type, player),
  c(EID, player_no, PlayerNo).

destroy_player @
c(EID, type, player) # passive
\
destroy_player(EID) <=>
  remove_component(EID, type),
  remove_component(EID, player_no).

%% player_control_unit(PlayerNo, EID), c(EIDPlayer, player_no, PlayerNo) # passive, c(EID, template, _) # passive ==> 
%%   c(EIDPlayer, player_control, EID).