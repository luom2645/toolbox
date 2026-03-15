import '../models/enemy.dart';

/// 关卡配置数据
class LevelConfig {
  final int level;
  final String name;
  final String description;
  final List<EnemyType> enemies;
  final int playerHp;
  final int playerMaxHp;
  final int goldReward;
  final int expReward;
  final String? story; // 剧情文本

  const LevelConfig({
    required this.level,
    required this.name,
    required this.description,
    required this.enemies,
    this.playerHp = 100,
    this.playerMaxHp = 100,
    this.goldReward = 50,
    this.expReward = 100,
    this.story,
  });
}

/// 剧情模式关卡配置表
class LevelDatabase {
  static const List<LevelConfig> storyLevels = [
    // 第 1 关 - 新手教学
    LevelConfig(
      level: 1,
      name: '初出茅庐',
      description: '第一次战斗，击败弱小的史莱姆',
      enemies: [EnemyType.slime],
      playerHp: 100,
      playerMaxHp: 100,
      goldReward: 30,
      expReward: 50,
      story: '你踏上了冒险之旅，前方出现了一只史莱姆...',
    ),

    // 第 2 关
    LevelConfig(
      level: 2,
      name: '哥布林侦察兵',
      description: '哥布林侦察兵在附近出没',
      enemies: [EnemyType.goblin, EnemyType.goblin],
      playerHp: 100,
      playerMaxHp: 100,
      goldReward: 50,
      expReward: 80,
      story: '哥布林侦察兵发现了你的踪迹，准备战斗！',
    ),

    // 第 3 关
    LevelConfig(
      level: 3,
      name: '骷髅战士',
      description: '古老的骷髅战士守护着这片土地',
      enemies: [EnemyType.skeleton],
      playerHp: 100,
      playerMaxHp: 100,
      goldReward: 70,
      expReward: 120,
      story: '骷髅战士从坟墓中爬出，阻挡你的去路...',
    ),

    // 第 4 关
    LevelConfig(
      level: 4,
      name: '兽人突袭',
      description: '兽人战士发起猛烈攻击',
      enemies: [EnemyType.orc, EnemyType.goblin],
      playerHp: 100,
      playerMaxHp: 100,
      goldReward: 90,
      expReward: 150,
      story: '兽人部落发现了你，他们不会轻易放过入侵者！',
    ),

    // 第 5 关 - 小 Boss
    LevelConfig(
      level: 5,
      name: '食人魔领主',
      description: '强大的食人魔领主坐镇前方',
      enemies: [EnemyType.ogre],
      playerHp: 100,
      playerMaxHp: 100,
      goldReward: 150,
      expReward: 250,
      story: '食人魔领主发出震耳欲聋的咆哮，准备迎接恶战！',
    ),

    // 第 6 关
    LevelConfig(
      level: 6,
      name: '黑暗法师',
      description: '邪恶的黑暗法师施展诅咒',
      enemies: [EnemyType.wizard, EnemyType.skeleton],
      playerHp: 100,
      playerMaxHp: 100,
      goldReward: 120,
      expReward: 200,
      story: '黑暗法师的咒语在空气中回荡，小心他的魔法！',
    ),

    // 第 7 关
    LevelConfig(
      level: 7,
      name: '龙巢入口',
      description: '巨龙的手下守卫着巢穴',
      enemies: [EnemyType.dragonWhelp, EnemyType.dragonWhelp],
      playerHp: 100,
      playerMaxHp: 100,
      goldReward: 180,
      expReward: 300,
      story: '你来到了龙巢入口，幼龙们已经察觉到你的存在...',
    ),

    // 第 8 关
    LevelConfig(
      level: 8,
      name: '恶魔之门',
      description: '恶魔从地狱之门涌出',
      enemies: [EnemyType.demon, EnemyType.skeleton],
      playerHp: 100,
      playerMaxHp: 100,
      goldReward: 200,
      expReward: 350,
      story: '地狱之门开启，恶魔大军即将降临！',
    ),

    // 第 9 关
    LevelConfig(
      level: 9,
      name: '远古守护者',
      description: '远古巨龙守护着宝藏',
      enemies: [EnemyType.ancientDragon],
      playerHp: 100,
      playerMaxHp: 100,
      goldReward: 300,
      expReward: 500,
      story: '远古巨龙睁开双眼，千年的沉睡结束了...',
    ),

    // 第 10 关 - 最终 Boss
    LevelConfig(
      level: 10,
      name: '魔王降临',
      description: '最终决战！击败魔王拯救世界',
      enemies: [EnemyType.demonLord],
      playerHp: 100,
      playerMaxHp: 100,
      goldReward: 500,
      expReward: 1000,
      story: '魔王从黑暗王座站起，最终决战开始了！这是你证明自己的时刻！',
    ),
  ];

  /// 根据关卡 ID 获取配置
  static LevelConfig? getLevel(int level) {
    if (level < 1 || level > storyLevels.length) return null;
    return storyLevels[level - 1];
  }

  /// 获取总关卡数
  static int get totalLevels => storyLevels.length;

  /// 检查是否为 Boss 关卡 (每 5 关)
  static bool isBossLevel(int level) => level % 5 == 0;
}
