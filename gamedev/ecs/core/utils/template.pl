template_class_get(Catalog, Template, Class) :-
  template(Catalog, Template, class, Class), !.

template_parent_get(Catalog, Template, Parent) :- 
  template(Catalog, Template, parent, Parent), !.

template_field_value_get(Catalog, Template, Field, Value) :-
  (   template(Catalog, Template, Field, Value)
  ->  true  
  ;   template_parent_get(Catalog, Template, Parent),
      template_field_value_get(Catalog, Parent, Field, Value)
  ), !.