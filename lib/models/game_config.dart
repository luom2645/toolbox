/// 游戏配置常量
class GameConfig {
  // ==================== 对局配置 ====================
  /// 单局时长 (秒) - 15 分钟
  static const int gameDuration = 900;
  
  /// 总波次数
  static const int totalWaves = 20;
  
  /// 每波间隔 (秒)
  static const int waveInterval = 45;
  
  /// BOSS 波次
  static const List<int> bossWaves = [10, 20];
  
  /// 宝藏怪波次 (固定出现)
  static const List<int> treasureWaves = [5, 10, 15, 20];
  
  // ==================== 场地配置 ====================
  /// 初始场地大小
  static const int initialGridRows = 3;
  static const int initialGridCols = 3;
  
  /// 最大场地大小
  static const int maxGridRows = 4;
  static const int maxGridCols = 5;
  
  /// 场地扩展配置
  static const Map<int, FieldExpansion> fieldExpansions = {
    1: FieldExpansion(3, 4, 100),   // 3×4, 100 经验
    2: FieldExpansion(4, 4, 300),   // 4×4, 300 经验
    3: FieldExpansion(4, 5, 600),   // 4×5, 600 经验
  };
  
  // ==================== 射程配置 ====================
  /// 各稀有度射程 (不包含自身格子)
  static const Map<int, int> rarityRanges = {
    1: 5,  // 普通
    2: 6,  // 优秀
    3: 7,  // 史诗
    4: 8,  // 传奇
    5: 9,  // 神话
  };
  
  // ==================== 时间配置 ====================
  /// 定时金币间隔 (秒)
  static const int timedGoldInterval = 60;
  
  /// 定时金币基础值
  static const int timedGoldBase = 200;
  
  // ==================== 利息配置 ====================
  /// 利息计算基数
  static const int interestBase = 50;
  
  /// 利息上限
  static const int interestCap = 150;
  
  // ==================== 商店配置 ====================
  /// 每波免费刷新次数
  static const int freeRefreshPerWave = 3;
  
  /// 额外刷新成本
  static const int extraRefreshCost = 20;
  
  // ==================== 合成配置 ====================
  /// 是否启用合成返还金币
  static const bool enableMergeRefund = false;
  
  // ==================== BOSS 配置 ====================
  /// BOSS 对百分比伤害的抗性
  static const double bossPercentDamageResist = 0.8;
  
  /// BOSS 对控制效果的抗性
  static const Map<String, double> bossCrowdControlResist = {
    'stun': 0.9,      // 眩晕
    'freeze': 0.8,    // 冰冻
    'petrify': 0.75,  // 石化
    'poison': 0.5,    // 中毒
    'burn': 0.4,      // 燃烧
    'curse': 0.6,     // 诅咒
    'slow': 0.5,      // 减速
  };
}

/// 场地扩展配置
class FieldExpansion {
  final int rows;
  final int cols;
  final int expRequired;
  
  const FieldExpansion(this.rows, this.cols, this.expRequired);
}

/// 游戏模式
enum GameMode {
  story,      // 剧情模式
  endless,    // 无尽之塔
  daily,      // 每日挑战
  worldBoss,  // 世界 BOSS
  arena,      // 竞技场
}

/// 难度等级
enum Difficulty {
  easy,
  normal,
  hard,
  nightmare,
}
