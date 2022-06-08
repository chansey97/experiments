%% c_unit
class(c_unit, super, null).
class_field(c_unit, name, {pred:string, default:""}).
class_field(c_unit, bounds, {pred:number, default:0}).
class_field(c_unit, life_starting, {pred:number, default:0}).
class_field(c_unit, life_max, {pred:number, default:0}).
class_field(c_unit, energy_starting, {pred:number, default:0}).
class_field(c_unit, energy_max, {pred:number, default:0}).
class_field(c_unit, speed, {pred:number, default:0}).
class_field(c_unit, abils, {pred:is_list, default:[]}).
class_field(c_unit, weapons, {pred:is_list, default:[]}).

