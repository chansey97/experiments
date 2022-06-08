class_fields_get(Class, Fields) :-
    (   class(Class, super, SuperClass)
    ->  class_fields_get(SuperClass, Fields1),
        findall(Field-Info, class_field(Class, Field, Info) , Fields2),
        append(Fields1, Fields2, Fields)
    ;   findall(Field-Info, class_field(Class, Field, Info) , Fields)
    ).

%% ?- class_fields_get(c_abil_effect_target, L).
%@ L = [transient-{pred:atom,default:false},cost_energy-{pred:integer,default:0},cost_cooldown-{pred:integer,default:0},effects-{pred:is_list,default:[]},range-{pred:integer,default:0}].
