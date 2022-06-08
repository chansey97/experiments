%% common logic for every actor?

%% 'actor entity' 的创建，基于在 'actor template entity' 上的小 trigger，那些 trigger handle unit 创建事件来创建真正的 'actor entity'。
%% 由于采用了 ECS 系统，不同类型的 actor 可以都可以 handle 事件，这些逻辑没必要一定依附于类，即：
%% 有些逻辑，不同的 Actor 类 有不同的逻辑，这种情况，基于 OOP 的方式来处理 （OOP 本质上也只是一个 class 组件，但是 system 支持 super call）。
%% 有些逻辑，不同的 Actor 类 有相同的逻辑，这种情况，基于 ECS 的方式来处理。

%% 当 'actor entity' 创建之后，'actor entity' 本身就能 handle event，此时
%% CHR heads 上接受 'actor entity' 和 'actor template' 两个组件。
%% CHR/ECS 的一个优势在于：handle 事件的人，不需要是一个特定对象，而可以是一个关联。
