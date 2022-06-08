
class_fields_get(Class, Fields) :-
  (   class(id = Class, super = SuperClass, Fields0)
  ->  (   SuperClass == null
      ->  Fields = Fields0
      ;   class_fields_get(SuperClass, Fields1),
          append(Fields1, Fields0, Fields)
      )
  ;   format("class_fields_get, class ~w does not exist.~n", [Class])
  ).

%% ?- class_fields_get(c_abil_effect_target, L).
%% L = [field(name=name,pred=string,default=),
%%      field(name=transient,pred=atom,default=false),
%%      field(name=cost_energy,pred=number,default=0),
%%      field(name=cost_cooldown,pred=number,default=0),
%%      field(name=effects,pred=is_list,default=[]),
%%      field(name=range,pred=number,default=0)].
