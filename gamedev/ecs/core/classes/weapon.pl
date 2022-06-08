
%% c_weapon
class(c_weapon, super, null).
class_field(c_weapon, name, {pred:string, default:""}).

%% c_weapon_legacy
class(c_weapon_legacy, super, c_weapon).
class_field(c_weapon_legacy, arc, {pred:number, default:0}).
class_field(c_weapon_legacy, range, {pred:number, default:0}).
class_field(c_weapon_legacy, period, {pred:integer, default:0}).
class_field(c_weapon_legacy, damage_point, {pred:number, default:0}).
class_field(c_weapon_legacy, backswing, {pred:number, default:0}).
class_field(c_weapon_legacy, effect, {pred:atom, default:null}).
