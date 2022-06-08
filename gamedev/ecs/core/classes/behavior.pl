%% c_behavior
class(c_behavior, super, null).
class_field(c_behavior, name, {pred:string, default:""}).

%% c_behavior_buff
class(c_behavior_buff, super, c_behavior).
class_field(c_behavior_buff, duration, {pred:number, default:0}).
class_field(c_behavior_buff, init_effect, {pred:atom, default:null}).
class_field(c_behavior_buff, final_effect, {pred:atom, default:null}).
class_field(c_behavior_buff, period, {pred:integer, default:0}).
class_field(c_behavior_buff, period_count, {pred:integer, default:0}).
class_field(c_behavior_buff, periodic_effect, {pred:atom, default:null}).

