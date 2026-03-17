/// 英雄类型枚举 (无坦克)
enum HeroType {
  warrior,   // 战士 - 近战物理输出，均衡型
  mage,      // 法师 - 远程魔法爆发，高伤害低血量
  assassin,  // 刺客 - 高暴击高闪避，单体爆发
  support,   // 辅助 - 治疗增益，团队核心
  marksman,  // 射手 - 远程物理持续输出
}

/// 英雄类型属性配置
class HeroTypeConfig {
  final HeroType type;
  final String name;
  final String icon;
  final String description;
  
  // 属性系数 (相对于基准值)
  final double hpMultiplier;      // 血量系数
  final double attackMultiplier;  // 攻击系数
  final double defenseMultiplier; // 防御系数
  final double speedMultiplier;   // 速度系数
  final double critRateBonus;     // 暴击率加成
  final double critDmgBonus;      // 暴击伤害加成
  
  const HeroTypeConfig({
    required this.type,
    required this.name,
    required this.icon,
    required this.description,
    required this.hpMultiplier,
    required this.attackMultiplier,
    required this.defenseMultiplier,
    required this.speedMultiplier,
    required this.critRateBonus,
    required this.critDmgBonus,
  });
  
  /// 所有英雄类型配置
  static const List<HeroTypeConfig> configs = [
    HeroTypeConfig(
      type: HeroType.warrior,
      name: '战士',
      icon: '⚔️',
      description: '近战物理输出，攻守兼备',
      hpMultiplier: 1.0,
      attackMultiplier: 1.0,
      defenseMultiplier: 1.0,
      speedMultiplier: 1.0,
      critRateBonus: 0.0,
      critDmgBonus: 0.0,
    ),
    HeroTypeConfig(
      type: HeroType.mage,
      name: '法师',
      icon: '🔮',
      description: '远程魔法爆发，高伤害低血量',
      hpMultiplier: 0.7,
      attackMultiplier: 1.4,
      defenseMultiplier: 0.7,
      speedMultiplier: 0.9,
      critRateBonus: 0.1,
      critDmgBonus: 0.2,
    ),
    HeroTypeConfig(
      type: HeroType.assassin,
      name: '刺客',
      icon: '🗡️',
      description: '高暴击高闪避，单体爆发',
      hpMultiplier: 0.8,
      attackMultiplier: 1.2,
      defenseMultiplier: 0.8,
      speedMultiplier: 1.3,
      critRateBonus: 0.2,
      critDmgBonus: 0.5,
    ),
    HeroTypeConfig(
      type: HeroType.support,
      name: '辅助',
      icon: '💚',
      description: '治疗增益，团队核心',
      hpMultiplier: 0.9,
      attackMultiplier: 0.7,
      defenseMultiplier: 0.9,
      speedMultiplier: 1.1,
      critRateBonus: 0.0,
      critDmgBonus: 0.0,
    ),
    HeroTypeConfig(
      type: HeroType.marksman,
      name: '射手',
      icon: '🏹',
      description: '远程物理持续输出',
      hpMultiplier: 0.85,
      attackMultiplier: 1.15,
      defenseMultiplier: 0.85,
      speedMultiplier: 1.0,
      critRateBonus: 0.15,
      critDmgBonus: 0.3,
    ),
  ];
  
  /// 根据类型获取配置
  static HeroTypeConfig getByType(HeroType type) {
    return configs.firstWhere((c) => c.type == type);
  }
  
  /// 获取类型名称
  static String getName(HeroType type) {
    return getByType(type).name;
  }
  
  /// 获取类型图标
  static String getIcon(HeroType type) {
    return getByType(type).icon;
  }
}
