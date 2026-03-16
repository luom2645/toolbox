/// 局外英雄养成系统
/// 英雄升阶 (永久)，解锁条件：通关对应地图

/// 英雄阶位枚举
enum HeroTier {
  tier1, // 1 阶 - 初始
  tier2, // 2 阶 - 通关地图 1
  tier3, // 3 阶 - 通关地图 3
  tier4, // 4 阶 - 通关地图 5
  tier5, // 5 阶 - 通关地图 10
}

/// 英雄养成进度
class HeroProgression {
  final String heroId;
  HeroTier tier; // 当前阶位
  final DateTime unlockedAt; // 解锁时间

  HeroProgression({
    required this.heroId,
    this.tier = HeroTier.tier1,
    DateTime? unlockedAt,
  }) : unlockedAt = unlockedAt ?? DateTime.now();

  /// 局内起始星级 = 阶位
  int get startStar => tier.index + 1;

  /// 是否可升阶
  bool canUpgrade(int completedMap) {
    switch (tier) {
      case HeroTier.tier1:
        return completedMap >= 1;
      case HeroTier.tier2:
        return completedMap >= 3;
      case HeroTier.tier3:
        return completedMap >= 5;
      case HeroTier.tier4:
        return completedMap >= 10;
      case HeroTier.tier5:
        return false; // 已满阶
    }
  }

  /// 升阶
  HeroProgression upgrade() {
    if (tier == HeroTier.tier5) return this;
    return HeroProgression(
      heroId: heroId,
      tier: HeroTier.values[tier.index + 1],
      unlockedAt: DateTime.now(),
    );
  }

  /// 从 JSON 创建
  factory HeroProgression.fromJson(Map<String, dynamic> json) {
    return HeroProgression(
      heroId: json['heroId'] as String,
      tier: HeroTier.values[json['tier'] as int],
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
    );
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      'heroId': heroId,
      'tier': tier.index,
      'unlockedAt': unlockedAt.toIso8601String(),
    };
  }
}

/// 玩家养成进度管理
class PlayerProgression {
  int completedMap = 0; // 已通关最高地图
  Map<String, HeroProgression> heroes = {}; // 英雄养成进度

  /// 通关地图
  void completeMap(int mapId) {
    if (mapId > completedMap) {
      completedMap = mapId;
      _unlockHeroes();
    }
  }

  /// 解锁新阶位英雄
  void _unlockHeroes() {
    // 根据通关地图解锁对应阶位
    // 具体逻辑由游戏管理
  }

  /// 获取英雄起始星级
  int getHeroStartStar(String heroId) {
    final progression = heroes[heroId];
    if (progression == null) return 1;
    return progression.startStar;
  }

  /// 升阶英雄
  void upgradeHero(String heroId) {
    final progression = heroes[heroId];
    if (progression != null && progression.canUpgrade(completedMap)) {
      heroes[heroId] = progression.upgrade();
    }
  }
}
