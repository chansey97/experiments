load_templates :-
  forall2(raw_template(Catalog, ID, class, Class), create_template(Catalog, ID, Class, _)).

create_template(Catalog, ID, Class, EID), next_e(EID0) # passive <=>
  EID = EID0,
  NextEID is EID0+1, next_e(NextEID),
  c(EID, type, template),
  c(EID, catalog, Catalog),
  c(EID, id, ID),
  c(EID, class, Class),
  class_fields_get(Class, Fields),
  maplist({Catalog, ID, EID}/[Field]>>
         (   Field = field(name=Name,pred=Pred,default=Default),
             (   raw_template_field_value_get(Catalog, ID, Name, Value) 
             ->  (   call(Pred, Value)
                 ->  c(EID, Name, Value)
                 ;   format("create_template Failed. Catalog ~w ID ~w.~n", [Catalog, ID]),
                     format("create_template Failed. The field ~w's type  ~w and value ~w mismatch. ~n", [Name, Pred, Value]),
                     fail
                 )
             ;   c(EID, Name, Default)
             )
         ), Fields).

%% TODO: modify to use CHR

%% template_class_get(Catalog, Template, Class) :-
%%   template(Catalog, Template, class, Class), !.

%% template_parent_get(Catalog, Template, Parent) :- 
%%   template(Catalog, Template, parent, Parent), !.

%% template_field_value_get(Catalog, Template, Field, Value) :-
%%   (   template(Catalog, Template, Field, Value)
%%   ->  true  
%%   ;   template_parent_get(Catalog, Template, Parent),
%%       template_field_value_get(Catalog, Parent, Field, Value)
%%   ), !.