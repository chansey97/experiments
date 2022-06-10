
load_classes :-
  forall2(class(id = ID, super = SuperClass, _), create_class(ID, SuperClass, _)).

create_class(ID, SuperClass, EID), next_e(EID0) # passive <=>
  EID = EID0,
  NextEID is EID0+1, next_e(NextEID),
  c(EID, type, class),
  c(EID, id, ID),
  (   SuperClass = null
  ->  true
  ;   c(EID, super, SuperClass)
  ).
  
