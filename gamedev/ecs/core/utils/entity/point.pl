create_point @
create_point(X, Y, EID), next_e(ID) # passive <=>
  EID=ID,
  NextID is ID+1, next_e(NextID),
  c(EID, type, point),
  c(EID, position, X-Y).

destroy_point @
c(EID, type, point) # passive
\
destroy_point(EID) <=>
  remove_component(EID, type),
  remove_component(EID, position).
