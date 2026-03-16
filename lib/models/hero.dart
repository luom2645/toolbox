/// 英雄稀有度
enum Rarity {
  common,      // 普通 (白色)
  uncommon,    // 优秀 (绿色)
  rare,        // 稀有 (蓝色)
  epic,        // 史诗 (紫色)
  legendary,   // 传奇 (橙色)
  mythic,      // 神话 (红色)
}

/// 英雄类型
enum HeroType {
  warrior,   // 战士 - 近战物理输出
  mage,      // 法师 - 远程魔法输出
  tank,      // 坦克 - 高防御高血量
  assassin,  // 刺客 - 高暴击高闪避
  support,   // 辅助 - 治疗增益
  marksman,  // 射手 - 远程物理持续输出
}

/// 元素类型
enum Element {
  fire,    // 火 - 高爆发
  water,   // 水 - 治疗控制
  wind,    // 风 - 高闪避高速度
  light,   // 光 - 神圣加成
  dark,    // 暗 - 诅咒吸血
  none,    // 无 - 中性
}

/// 星级境界
enum StarRealm {
  novice,      // 新手境界 (2 星)
  elite,       // 精英境界 (8 星)
  master,      // 大师境界 (32 星)
  legendary,   // 传奇境界 (128 星)
  mythic,      // 神话境界 (512 星)
  ballGod,     // 球球之神 (2048 星)
}

/// 英雄模型
class Hero {
  final String id;
  final String name;
  final Rarity rarity;
  final HeroType type;
  final Element element;
  
  // 等级相关
  int level;
  int experience;
  int stars;
  
  // 基础属性
  int baseHp;
  int baseAttack;
  int baseDefense;
  int baseSpeed;
  int baseCritRate;
  int baseCritDmg;
  
  // 当前属性 (含加成)
  int get currentHp => (baseHp * levelMultiplier * starBonus).round();
  int get currentAttack => (baseAttack * levelMultiplier * starBonus * elementBonus).round();
  int get currentDefense => (baseDefense * levelMultiplier * starBonus).round();
  int get currentSpeed => (baseSpeed * starBonus).round();
  int get currentCritRate => (baseCritRate * starBonus).clamp(0, 100);
  int get currentCritDmg => (baseCritDmg * starBonus).round();
  
  // 状态
  int currentHp; // 当前血量
  bool isAlive;
  
  Hero({
    required this.id,
    required this.name,
    required this.rarity,
    required this.type,
    required this.element,
    this.level = 1,
    this.experience = 0,
    this.stars = 0,
    this.baseHp = 100,
    this.baseAttack = 10,
    this.baseDefense = 5,
    this.baseSpeed = 100,
    this.baseCritRate = 5,
    this.baseCritDmg = 150,
    required this.currentHp,
    this.isAlive = true,
  });

  /// 等级倍率
  double get levelMultiplier => 1.0 + (level - 1) * 0.1;

  /// 星级加成 (每星 +5% 属性)
  double get starBonus => 1.0 + stars * 0.05;

  /// 元素加成 (同元素队伍加成)
  double get elementBonus => 1.0; // TODO: 队伍元素羁绊

  /// 获取境界
  StarRealm get realm {
    if (stars < 2) return StarRealm.novice;
    if (stars < 8) return StarRealm.elite;
    if (stars < 32) return StarRealm.master;
    if (stars < 128) return StarRealm.legendary;
    if (stars < 512) return StarRealm.mythic;
    return StarRealm.ballGod;
  }

  /// 境界名称
  String get realmName {
    switch (realm) {
      case StarRealm.novice:
        return '新手';
      case StarRealm.elite:
        return '精英';
      case StarRealm.master:
        return '大师';
      case StarRealm.legendary:
        return '传奇';
      case StarRealm.mythic:
        return '神话';
      case StarRealm.ballGod:
        return '球球之神';
    }
  }

  /// 境界进度 (当前境界内的星级进度)
  double get realmProgress {
    switch (realm) {
      case StarRealm.novice:
        return stars / 2;
      case StarRealm.elite:
        return (stars - 2) / 6;
      case StarRealm.master:
        return (stars - 8) / 24;
      case StarRealm.legendary:
        return (stars - 32) / 96;
      case StarRealm.mythic:
        return (stars - 128) / 384;
      case StarRealm.ballGod:
        return (stars - 512) / 1536;
    }
  }

  /// 获取稀有度颜色
  int get rarityColor {
    switch (rarity) {
      case Rarity.common:
        return 0xB0B0B0;  // 白色
      case Rarity.uncommon:
        return 0x4CAF50;  // 绿色
      case Rarity.rare:
        return 0x2196F3;  // 蓝色
      case Rarity.epic:
        return 0x9C27B0;  // 紫色
      case Rarity.legendary:
        return 0xFF9800;  // 橙色
      case Rarity.mythic:
        return 0xF44336;  // 红色
    }
  }

  /// 获取稀有度名称
  String get rarityName {
    switch (rarity) {
      case Rarity.common:
        return '普通';
      case Rarity.uncommon:
        return '优秀';
      case Rarity.rare:
        return '稀有';
      case Rarity.epic:
        return '史诗';
      case Rarity.legendary:
        return '传奇';
      case Rarity.mythic:
        return '神话';
    }
  }

  /// 获取类型名称
  String get typeName {
    switch (type) {
      case HeroType.warrior:
        return '战士';
      case HeroType.mage:
        return '法师';
      case HeroType.tank:
        return '坦克';
      case HeroType.assassin:
        return '刺客';
      case HeroType.support:
        return '辅助';
      case HeroType.marksman:
        return '射手';
    }
  }

  /// 获取元素名称
  String get elementName {
    switch (element) {
      case Element.fire:
        return '火';
      case Element.water:
        return '水';
      case Element.wind:
        return '风';
      case Element.light:
        return '光';
      case Element.dark:
        return '暗';
      case Element.none:
        return '无';
    }
  }

  /// 获取元素图标
  String get elementIcon {
    switch (element) {
      case Element.fire:
        return '🔥';
      case Element.water:
        return '💧';
      case Element.wind:
        return '💨';
      case Element.light:
        return '✨';
      case Element.dark:
        return '🌑';
      case Element.none:
        return '⚪';
    }
  }

  /// 获取类型图标
  String get typeIcon {
    switch (type) {
      case HeroType.warrior:
        return '⚔️';
      case HeroType.mage:
        return '🔮';
      case HeroType.tank:
        return '🛡️';
      case HeroType.assassin:
        return '🗡️';
      case HeroType.support:
        return '💚';
      case HeroType.marksman:
        return '🏹';
    }
  }

  /// 获得经验
  Hero gainExperience(int exp) {
    final newExp = experience + exp;
    final expNeeded = level * 100;
    
    if (newExp >= expNeeded) {
      // 升级
      return copyWith(
        level: level + 1,
        experience: newExp - expNeeded,
        currentHp: currentHp + baseHp, // 升级回血
      );
    }
    
    return copyWith(experience: newExp);
  }

  /// 升星 (需要相同英雄)
  Hero promoteStar() {
    return copyWith(stars: stars + 1);
  }

  /// 受到伤害
  Hero takeDamage(int damage) {
    final actualDmg = (damage * (100 - currentDefense).clamp(0, 80) / 100).round();
    final newHp = currentHp - actualDmg;
    return copyWith(
      currentHp: newHp.clamp(0, currentHp),
      isAlive: newHp > 0,
    );
  }

  /// 治疗
  Hero heal(int amount) {
    return copyWith(
      currentHp: (currentHp + amount).clamp(0, currentHp),
    );
  }

  Hero copyWith({
    int? level,
    int? experience,
    int? stars,
    int? currentHp,
    bool? isAlive,
  }) {
    return Hero(
      id: id,
      name: name,
      rarity: rarity,
      type: type,
      element: element,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      stars: stars ?? this.stars,
      baseHp: baseHp,
      baseAttack: baseAttack,
      baseDefense: baseDefense,
      baseSpeed: baseSpeed,
      baseCritRate: baseCritRate,
      baseCritDmg: baseCritDmg,
      currentHp: currentHp ?? this.currentHp,
      isAlive: isAlive ?? this.isAlive,
    );
  }

  @override
  String toString() {
    return 'Hero($name - $rarityName $typeName - Lv.$level $stars 星)';
  }
}
