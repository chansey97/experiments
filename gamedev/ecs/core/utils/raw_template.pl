%% template(catalog = abil, id = psi_storm,
%%          [class = c_abil_effect_target,
%%           parent = t_abil_effect_target],     
%%          [name = 'Psi Storm',     
%%           cost_energy = 75,
%%           cost_cooldown = 3,
%%           range = 7,     
%%           effects = [psi_storm_persistent]
%%          ]).

%@ Y = [template,catalog=abil,id=psi_storm,[class=c_abil_effect_target,parent=t_abil_effect_target],[name=Psi Storm,cost_energy=75,cost_cooldown=3,range=7,effects=[psi_storm_persistent]]].

load_raw_templates(Directory) :-
  %% format("load_raw_templates Directory ~w~n", [WildCard]),
  string_concat(Directory, "/*.pl", WildCard),
  expand_file_name(WildCard, Files),
  maplist({Directory}/[File]>>load_raw_template(File), Files).

load_raw_template(File) :-
  %% format("load_raw_template ~w ~n", [File]),
  read_file_to_terms(File, Terms, []),
  maplist([Term]>>
         (   Term =.. [template, catalog=Catalog, id=ID, Heads, Fields]
         ->  (   raw_template(Catalog, ID, _, _)
             ->  format("load_raw_template Error. The template ~w ~w is duplicate.~n", [Catalog, ID]),
                 false
             ;   maplist({Catalog, ID}/[Head]>>(Head=(K=V), assertz(raw_template(Catalog, ID, K, V))), Heads),
                 maplist({Catalog, ID}/[Field]>>(Field=(K=V), assertz(raw_template_field(Catalog, ID, K, V))), Fields)
             )
         ;   format("load_raw_template Warning. The term ~w is not a template, ignored.~n", [Term])
         ), Terms).

raw_template_class_get(Catalog, ID, Class) :-
  raw_template(Catalog, ID, class, Class), !.

raw_template_parent_get(Catalog, ID, Parent) :-
  raw_template(Catalog, ID, parent, Parent), !.

raw_template_field_value_get(Catalog, ID, Field, Value) :-
  (   raw_template_field(Catalog, ID, Field, Value)
  ->  true  
  ;   raw_template_parent_get(Catalog, ID, Parent),
      raw_template_field_value_get(Catalog, Parent, Field, Value)
  ), !.

