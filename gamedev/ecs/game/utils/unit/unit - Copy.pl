create_unit @
create_unit(Template, X, Y, PlayerNo, EID), next_e(EID0) # passive <=>
  EID=EID0,
  NextEID is EID0+1, next_e(NextEID),
  template_field_value_get(unit, Template, class, Class),
  c(EID, type, unit),
  c(EID, class, Class),
  c(EID, template, Template),
  c(EID, position, X-Y),
  c(EID, player_no, PlayerNo),
  c(EID, event_unit_create, Class).

destory_unit @
c(EID, type, unit) # passive,
c(EID, class, Class) # passive
\
destroy_unit(EID)
<=>
  c(EID, event_unit_destroy, Class),
  remove_component(EID, type),
  remove_component(EID, class),
  remove_component(EID, template),
  remove_component(EID, position),
  remove_component(EID, player_no).

%% TODO: kill_unit, etc.

unit_replace_template @
c(EID, type, unit) # passive,
c(EID, class, Class) # passive
\
replace_unit_template(EID, Template)
<=>
  c(EID, event_unit_replace_template, Class, Template).


%% AID should be null or because of consider queue?

unit_issue_order @
c(EID, type, unit) # passive,
c(EID, order, AID) # passive,
\
unit_issue_order(EID, order_targeting_unit(AbilTemplate, UID))
<=>
  ignore(AID \= null, abil_cancel(AID)),
  abil_start(AID).

%% 究竟让abil自己可以相互cancel，还是专门做一个order系统？
%% 让abil自己相互cancel的好处是，我不用在外部考虑check target的问题，因为全部由abil自己处理
%% 问题还有queue的问题。。abil要处理queue吗？
%% 是不是有的abil甚至可以改变queue?

%% 也就是说只需要一个abil_start即可，问题unit有多个同样template的技能，执行哪一个还是要unit决定

%% 一个问题是究竟要不要abil_start with AID?
%% 

%% unit_start_abil @
%% c(UID, abils, AIDs) # passive,
%% c(AID, template, Template) # passive
%% \
%% c(UID, event_unit_start_abil, c_unit, Template)
%% <=>
%%   memberchk(AID, AIDs),
%%   template_class_get(abil, Template, Class),
%%   c(AID, event_abil_check, Class)  %<-- 这个玩意执行的时候，究竟在上面要不要 attach 一个 target，感觉是要的，但是如果失败就要去掉吗？感觉 target 是在order上的，不是在abil上
%%                                    %也就是说，abil应该可以看到order
%%                                    %那么在ui层怎么check？用 util?
%%   |
%%   c(AID, event_abil_execute, Class).

%% unit_start_abil_cleanup @
%% c(UID, event_unit_start_abil, c_unit, Template) <=> true.


unit_issue_order @
c(UID, type, unit) # passive, % alive
\
unit_issue_order(UID, order_targeting_unit(AbilTemplate, TargetUnitiD))
<=>
c(UID, order_abil, AbilTemplate),
c(UID, order_target_unit, TargetUnitiD),
c(UID, event_unit_issue_order, c_unit).

%% 问题：这里 是否要有一个 cleanup 来删除立即删除 order_abil order_target_unit shifou after event_unit_issue_irder
%% 问题：event_unit_issue_order这个事件自己是由发送者删除吗？还是接收者？感觉发送者还是应该删除的，因为无论接收者是否可能吃掉

%% unit system:
event_unit_issue_order @
c(UID, type, unit) # passive,
c(UID, abils, AIDs) # passive,
c(AID, type, abil) # passive,
c(AID, template, AbilTemplate) # passive
\
c(UID, event_unit_issue_order, c_unit),
%% 这里的order_abil其实是try，并不一定真正会执行的
c(UID, order_abil, AbilTemplate), %% 这里需要删除吗？ 如果删除掉，则需要重新attach到对应的abil上，问题是什么时候attach，肯定不能在abil_check的时候attach which is entailment
                                  %% (   真的不行吗？最后删除不就行了？)
                                  %% 一种方法是：这些order保留 which 表达 executing abil，但只有真正abik_execute才会保留，否则就在最后去掉，比如：abil_check失败，的话就去掉
c(UID, order_target_unit, TargetUnitID),
<=>
  memberchk(AID, AIDs),
  template_class_get(abil, Template, Class),
  %% c(AID, event_abil_check, Class)  %<-- 这个玩意执行的时候，究竟在上面要不要 attach 一个 target，感觉是要的，但是如果失败就要去掉吗？感觉 target 是在order上的，不是在abil上
  %%                                  %也就是说，abil应该可以看到order
  %%                                  %那么在ui层怎么check？用 util?
  abil_check(AID, TargetUnitID) % => c(AID, event_abil_check, Class), which can be used in UI, abil_check_no_target, abil_check_target_point, abil_check_target_unit
  |
  %% 这里有一个问题：你想abil_cancel必须找到那个正在运行的abil 或者全局abil attached at unit,或者用事件 或者说 这里应该是 unit_cancel_abil 而不是abil_cancel
  %% 如果没有正在运行的abil则不需要cancel（如果abil是瞬态，则根本不需要attach全局abil，因此可以得出attach全局正在运行的abil是由abil本身做的）  
  %% abil_cancel(..., ..., ...),% => c(AID, event_abil_cancel, Class) % cancel what? must be a global 组件 c(EID, executing_abil, null or AID)
  abil_execute(AID, ..., ...) % => c(AID, event_abil_execute, Class). 看看 owner_id 上是否有executing_abil=null是否打断取决于施法的技能，而不是被打断的技能
  %% 问：究竟是主动调用 abil_cancel 还是其他 with executing_abil 的 abil handle event_abil_execute? 当然是主动调，否则顺序不好处理
  %% 因为打断是由施法技能决定的，which 比如：stop 就是在执行里调用，因此对了
  %% c(AID, event_abil_execute, Class).
.
%% 问题是
%% 1. c(AID, event_abil_check, Class) 需要关注 order_abil, order_target_unit
%% 2. 怎么找到当前运行的abil然后去掉？
%% 3. 怎么兼容 queue? 用update处理，如果由update处理的话，那么unit这里也需要看到executing_abil了？ 这不是问题，因为它是全局值，但最好在issue order这里直接cancel，但不幸。。
%% 4. ui 层怎么办？
%% 感觉不太好办，因为这里abil_check假定已经存在order_abil和order_target_unit
%% 5. 怎么处理target和unit和普通执行？

%% 注意：
%% 总需要有一个全局的current_executing_abil组件 on unit
%% 否则你就要在unit update 里 check 其关联的所有abil的状态 玩实现 order queue
%% 或者干脆在 abil_cancel里去掉正在运行的abil自己，而execute里增加z正在运行的abil自己，当完成的时候remove掉


%% 有一个问题：
%% executing_abil 是一个全局值 默认是null
%% 这个全局值主要是为了可以方便找到正在执行的order abil，然后下一个命令可以cancel这个abil
%% 但它在event_unit_issue_order不使用这个值，而是让具体abil使用，因为是否打断abil应该由施法技能决定，而不是正在执行的技能决定
%% 但是当一个技能结束后，它设置executing_abil=null，如果要支持queue，那么在unit这里还要check这个值，来执行下一个技能

%% 换句话说，abil 要使用这个值， unit也要在使用这个值

%% current_order_abil
%% next_order_abil
%% next_order_abil_target_unit

%% abil_check
%% abil_cancel
%% abil_execute, execute肯定可以调用abil_cancel 考虑stop技能

