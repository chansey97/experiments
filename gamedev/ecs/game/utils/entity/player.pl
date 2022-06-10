
create_player(PlayerNo, EID),
next_e(EID0) # passive <=>
  EID=EID0,
  NextEID is EID0+1, next_e(NextEID),
  c(EID, type, player),
  c(EID, player_no, PlayerNo).

c(EID, type, player) # passive
\
destroy_player(EID) <=>
  remove_component(EID, type),
  remove_component(EID, player_no).

%% player_control_unit(PlayerNo, EID), c(EIDPlayer, player_no, PlayerNo) # passive, c(EID, template, _) # passive ==> 
%%   c(EIDPlayer, player_control, EID).