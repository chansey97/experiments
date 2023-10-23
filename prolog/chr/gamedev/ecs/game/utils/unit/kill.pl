
%% N.B.
%% Source and Target might be the same entity, so we can not depend on CHR heads.
%% ECS might only get the aspects of the current entity, it doesn't work for other entities.
%% Here distinct CasterID and TargetID must be use entailment tests.
%% 
%% BTW, if you want to get other entities' components, CHR doesn't help...
%% For example, if you want to get all the entities in some area which has specific components,
%% CHR heads doesn't heap, because CHR heads are statics.
%% You must use aux methods...