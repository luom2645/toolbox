/// 宝藏怪系统
/// 固定出现：第 5/10/15/20 波
/// 效果：随机 N 个英雄 +1 星 (不包含自身格子)

/// 宝藏怪等级
enum TreasureLevel {
  small,   // 小宝藏精 - 第 5 波
  medium,  // 中宝藏精 - 第 10 波
  large,   // 大宝藏精 - 第 15 波
  legend,  // 传说宝藏王 - 第 20 波
}

/// 宝藏怪配置
class TreasureMonster {
  final TreasureLevel level;
  final int wave; // 出现波次
  final int hp;
  final int minAffected; // 最小影响英雄数
  final int maxAffected; // 最大影响英雄数
  final int duration; // 逃跑时间 (秒)
  final int goldReward; // 金币奖励

  const TreasureMonster({
    required this.level,
    required this.wave,
    required this.hp,
    required this.minAffected,
    required this.maxAffected,
    required this.duration,
    required this.goldReward,
  });

  /// 所有宝藏怪配置
  static const Map<TreasureLevel, TreasureMonster> configs = {
    TreasureLevel.small: TreasureMonster(
      level: TreasureLevel.small,
      wave: 5,
      hp: 500,
      minAffected: 1,
      maxAffected: 2,
      duration: 30,
      goldReward: 200,
    ),
    TreasureLevel.medium: TreasureMonster(
      level: TreasureLevel.medium,
      wave: 10,
      hp: 2000,
      minAffected: 2,
      maxAffected: 4,
      duration: 30,
      goldReward: 400,
    ),
    TreasureModel.large: TreasureMonster(
      level: TreasureLevel.large,
      wave: 15,
      hp: 8000,
      minAffected: 4,
      maxAffected: 6,
      duration: 30,
      goldReward: 600,
    ),
    TreasureLevel.legend: TreasureMonster(
      level: TreasureLevel.legend,
      wave: 20,
      hp: 30000,
      minAffected: 6,
      maxAffected: 8,
      duration: 30,
      goldReward: 800,
    ),
  };

  /// 根据波次获取宝藏怪
  static TreasureMonster? getByWave(int wave) {
    for (final config in configs.values) {
      if (config.wave == wave) return config;
    }
    return null;
  }

  /// 是否是宝藏怪波次
  static bool isTreasureWave(int wave) {
    return configs.values.any((c) => c.wave == wave);
  }

  /// 获取影响英雄数量 (随机)
  int getAffectedCount() {
    return minAffected + (maxAffected - minAffected);
    // 实际游戏中使用 Random
  }

  /// 宝藏怪名称
  String get name {
    switch (level) {
      case TreasureLevel.small:
        return '小宝藏精';
      case TreasureLevel.medium:
        return '中宝藏精';
      case TreasureLevel.large:
        return '大宝藏精';
      case TreasureLevel.legend:
        return '传说宝藏王';
    }
  }

  /// 宝藏怪图标
  String get icon {
    switch (level) {
      case TreasureLevel.small:
        return '💰';
      case TreasureLevel.medium:
        return '💎';
      case TreasureLevel.large:
        return '👑';
      case TreasureLevel.legend:
        return '🌟';
    }
  }
}

/// 宝藏怪战斗状态
class ActiveTreasureMonster {
  final TreasureMonster config;
  int currentHp;
  DateTime spawnTime;
  bool hasEscaped;

  ActiveTreasureMonster({
    required this.config,
    required this.currentHp,
    DateTime? spawnTime,
    this.hasEscaped = false,
  }) : spawnTime = spawnTime ?? DateTime.now();

  /// 是否已死亡
  bool get isDead => currentHp <= 0;

  /// 是否超时逃跑
  bool get hasTimedOut {
    final elapsed = DateTime.now().difference(spawnTime).inSeconds;
    return elapsed >= config.duration;
  }

  /// 受到攻击
  int takeDamage(int damage) {
    currentHp -= damage;
    if (currentHp < 0) currentHp = 0;
    return currentHp;
  }
}
