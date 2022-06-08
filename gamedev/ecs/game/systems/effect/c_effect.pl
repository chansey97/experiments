%% common logic for every effect?


%% 技能 target 类型的鉴别 和 target 的有效性验证 是基于 effect 而不是 ability
%% 比如：CEffectLaunchMissile ImpactLocation 决定目标到底是 unit 还是 point，
%% CEffectLaunchMissilede ValidatorArray 验证 target unit 的有效性