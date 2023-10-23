%% movement_system @ update(move, FID), c(EID, velocity, V) #passive \ c(EID, position, X-Y) #passive <=>
%%   random(-1.0,1.0,Rand),
%%   X2 is X+Rand*V,
%%   Y2 is Y+Rand*V,
%%   c(EID, position, X2-Y2).
%% movement_system @ update(move, FID) <=> true.
