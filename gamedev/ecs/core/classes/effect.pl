
%% TODO: load from files? it is unnecessary though.

%% TODO: rename {} to s_class_field_constraint

%% c_effect
class(c_effect, super, null).
class_field(c_effect, name, {pred:string, default:""}).

%% c_effect_response
class(c_effect_response, super, c_effect).

%% c_effect_set
class(c_effect_set, super, c_effect).
class_field(c_effect_set, effects, {pred:is_list, default:[]}).

%% c_effect_apply_behavior
class(c_effect_apply_behavior, super, c_effect_response).
class_field(c_effect_apply_behavior, behavior, {pred:atom, default:null}).

%% c_effect_create_persistent
class(c_effect_create_persistent, super, c_effect_response).
class_field(c_effect_create_persistent, initial_effect, {pred:atom, default:null}).
class_field(c_effect_create_persistent, final_effect, {pred:atom, default:null}).
class_field(c_effect_create_persistent, periodic_effect, {pred:atom, default:null}).
class_field(c_effect_create_persistent, periodic_count, {pred:number, default:0}).
class_field(c_effect_create_persistent, periodic_duration,  {pred:number, default:0}).

%% c_effect_destroy_persistent
%% class(c_effect_destroy_persistent, super, c_effect_response).

%% c_effect_create_unit
%% class(c_effect_create_unit, super, c_effect_response).

%% c_effect_damage
class(c_effect_damage, super, c_effect_response).
class_field(c_effect_damage, amount, {pred:integer, default:0}).

%% c_effect_enum_area
class(c_effect_enum_area, super, c_effect_response).
class_field(c_effect_enum_area, area, {pred:number, default:2}).
class_field(c_effect_enum_area, area_effect, {pred:atom, default:null}).

%% c_effect_lanuch_missile
class(c_effect_lanuch_missile, super, c_effect_response).
class_field(c_effect_lanuch_missile, ammo_unit, {pred:atom, default:null}).

%% c_effect_modify_unit
class(c_effect_modify_unit, super, c_effect_response).
class_field(c_effect_modify_unit, life, {pred:is_struct(s_effect_modify_vital, 2),
                                         default:s_effect_modify_vital(change:0, change_fraction:0)}).
class_field(c_effect_modify_unit, energy, {pred:is_struct(s_effect_modify_vital, 2),
                                           default:s_effect_modify_vital(change:0, change_fraction:0)}).

%% class(c_effect_modify_unit, super, c_effect_response).
%% class_field(c_effect_modify_unit, life, {pred:[Term]>>functor(Term, s_effect_modify_vital, 2),
%%                                          default:s_effect_modify_vital(change:0, change_fraction:0)}).
%% class_field(c_effect_modify_unit, energy, {pred:[Term]>>functor(Term, s_effect_modify_vital, 2),
%%                                            default:s_effect_modify_vital(change:0, change_fraction:0)}).



%% ?- write_canonical({pred:[Term]>>functor(Term, s_effect_modify_vital, 2), default:s_effect_modify_vital(change:0, change_fraction:0)}).
%@ {','(:(pred,>>([A],functor(A,s_effect_modify_vital,2))),:(default,s_effect_modify_vital(:(change,0),:(change_fraction,0))))}
%@ true.

%% ?- Pred = [Term]>>functor(Term, s_effect_modify_vital, 2), call(Pred, s_effect_modify_vital(change:0, change_fraction:0)).
%@ Pred = [$VAR(Term)]>>functor($VAR(Term),s_effect_modify_vital,2).


%% ?- call(is_functor(s_effect_modify_vital, 2), s_effect_modify_vital(change:0, change_fraction:0)).
%@ true.
