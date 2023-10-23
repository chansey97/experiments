
class(id = c_weapon, super = null,
      [field(name = name,
             pred = string,
             default = "")
      ]).

class(id = c_weapon_legacy, super = c_weapon,
      [field(name = arc,
             pred = number,
             default = ""),
       field(name = range,
             pred = number,
             default = 0),
       field(name = period,
             pred = integer,
             default = 0),
       field(name = damage_point,
             pred = number,
             default = 0),
       field(name = backswing,
             pred = number,
             default = 0),
       field(name = effect,
             pred = atom,
             default = null)
      ]).