/// 敌人类型枚举
enum EnemyType {
  slime,       // 史莱姆
  goblin,      // 哥布林
  skeleton,    // 骷髅兵
  orc,         // 兽人战士
  darkKnight,  // 黑暗骑士
  dragon,      // 巨龙
  demonLord,   // 魔王
}

/// 敌人模型
class Enemy {
  final int id;
  final EnemyType type;
  final int level;
  int hp;
  final int maxHp;
  final int attack;
  final int x;
  final int y;
  bool isStunned;      // 是否眩晕
  bool isEnraged;      // 是否狂暴
  int stunTurns;       // 眩晕剩余回合
  bool hasRevived;     // 是否已复活

  Enemy({
    required this.id,
    required this.type,
    required this.level,
    required this.hp,
    required this.maxHp,
    required this.attack,
    required this.x,
    required this.y,
    this.isStunned = false,
    this.isEnraged = false,
    this.stunTurns = 0,
    this.hasRevived = false,
  });

  /// 敌人名称
  String get name {
    switch (type) {
      case EnemyType.slime:
        return level == 1 ? '小史莱姆' : '史莱姆';
      case EnemyType.goblin:
        return '哥布林';
      case EnemyType.skeleton:
        return '骷髅兵';
      case EnemyType.orc:
        return '兽人战士';
      case EnemyType.darkKnight:
        return '黑暗骑士';
      case EnemyType.dragon:
        return '巨龙';
      case EnemyType.demonLord:
        return '魔王';
    }
  }

  /// 敌人颜色
  int get colorValue {
    switch (type) {
      case EnemyType.slime:
        return 0xFF4CAF50;  // 绿色
      case EnemyType.goblin:
        return 0xFF8BC34A;  // 浅绿
      case EnemyType.skeleton:
        return 0xFF9E9E9E;  // 灰色
      case EnemyType.orc:
        return 0xFF795548;  // 棕色
      case EnemyType.darkKnight:
        return 0xFF3F51B5;  // 深蓝
      case EnemyType.dragon:
        return 0xFFF44336;  // 红色
      case EnemyType.demonLord:
        return 0xFF9C27B0;  // 紫色
    }
  }

  /// 敌人图标
  String get icon {
    switch (type) {
      case EnemyType.slime:
        return '💧';
      case EnemyType.goblin:
        return '👺';
      case EnemyType.skeleton:
        return '💀';
      case EnemyType.orc:
        return '👹';
      case EnemyType.darkKnight:
        return '🗡️';
      case EnemyType.dragon:
        return '🐉';
      case EnemyType.demonLord:
        return '👿';
    }
  }

  /// 特殊能力描述
  String get ability {
    switch (type) {
      case EnemyType.slime:
        return '分裂：死亡生成 2 个小史莱姆';
      case EnemyType.goblin:
        return '偷袭：优先攻击后排';
      case EnemyType.skeleton:
        return '复活：50% 概率重生';
      case EnemyType.orc:
        return '狂暴：血量<30% 攻击×2';
      case EnemyType.darkKnight:
        return '反伤：反弹 30% 伤害';
      case EnemyType.dragon:
        return '龙息：全场 AOE 伤害';
      case EnemyType.demonLord:
        return '末日审判：毁灭性打击';
    }
  }

  /// 检查是否死亡
  bool get isDead => hp <= 0;

  /// 受到伤害
  int takeDamage(int damage) {
    if (isStunned) {
      stunTurns--;
      if (stunTurns <= 0) isStunned = false;
      return 0; // 眩晕中不受伤害
    }

    // 反伤计算
    int actualDamage = damage;
    if (type == EnemyType.darkKnight) {
      actualDamage = (damage * 0.7).round();
    }

    // 狂暴检查
    if (type == EnemyType.orc) {
      final hpPercent = hp / maxHp;
      if (hpPercent < 0.3 && !isEnraged) {
        isEnraged = true;
      }
    }

    hp -= actualDamage;

    // 复活判定
    if (hp <= 0 && type == EnemyType.skeleton && !hasRevived) {
      if (DateTime.now().millisecondsSinceEpoch % 2 == 0) {
        hasRevived = true;
        hp = (maxHp * 0.5).round();
        return -1; // 返回 -1 表示复活
      }
    }

    return actualDamage;
  }

  /// 创建敌人 (根据关卡)
  factory Enemy.createForLevel(int level, int id, int x, int y) {
    EnemyType type;
    int hp, attack;

    if (level <= 5) {
      type = EnemyType.slime;
      hp = 10 + level * 2;
      attack = 2 + level;
    } else if (level <= 10) {
      type = EnemyType.goblin;
      hp = 25 + level * 3;
      attack = 5 + level;
    } else if (level <= 15) {
      type = EnemyType.skeleton;
      hp = 50 + level * 5;
      attack = 10 + level * 2;
    } else if (level <= 20) {
      type = EnemyType.orc;
      hp = 100 + level * 10;
      attack = 20 + level * 3;
    } else if (level <= 25) {
      type = EnemyType.darkKnight;
      hp = 250 + level * 20;
      attack = 40 + level * 5;
    } else if (level < 30) {
      type = EnemyType.dragon;
      hp = 1000 + level * 50;
      attack = 80 + level * 10;
    } else {
      type = EnemyType.demonLord;
      hp = 5000 + level * 100;
      attack = 150 + level * 20;
    }

    return Enemy(
      id: id,
      type: type,
      level: level,
      hp: hp,
      maxHp: hp,
      attack: attack,
      x: x,
      y: y,
    );
  }

  Enemy copyWith({
    int? hp,
    bool? isStunned,
    bool? isEnraged,
    int? stunTurns,
    bool? hasRevived,
  }) {
    return Enemy(
      id: id,
      type: type,
      level: level,
      hp: hp ?? this.hp,
      maxHp: maxHp,
      attack: attack,
      x: x,
      y: y,
      isStunned: isStunned ?? this.isStunned,
      isEnraged: isEnraged ?? this.isEnraged,
      stunTurns: stunTurns ?? this.stunTurns,
      hasRevived: hasRevived ?? this.hasRevived,
    );
  }
}
