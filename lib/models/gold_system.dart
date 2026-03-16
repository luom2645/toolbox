/// 金币系统
/// 包含：基础收入、定时收入、利息系统、金币加成

/// 金币来源枚举
enum GoldSource {
  waveReward,      // 波次奖励
  killSmall,       // 击杀小怪
  killElite,       // 击杀精英
  killBoss,        // 击杀 BOSS
  killTreasure,    // 击杀宝藏怪
  timedIncome,     // 定时收入
  interest,        // 利息
  skill,           // 技能获取
  bond,            // 羁绊加成
  other,           // 其他
}

/// 金币记录
class GoldRecord {
  final int amount;
  final GoldSource source;
  final DateTime timestamp;
  final String? description;

  GoldRecord({
    required this.amount,
    required this.source,
    DateTime? timestamp,
    this.description,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// 金币系统管理
class GoldSystem {
  int gold = 0; // 当前金币
  int totalEarned = 0; // 累计获取
  int totalSpent = 0; // 累计消耗
  List<GoldRecord> history = []; // 金币记录

  // 利息配置
  static const int interestInterval = 50; // 每 50 金币
  static const int interestPerUnit = 1; // +1 利息
  static const int interestCap = 150; // 利息上限

  // 定时收入配置
  static const int timedIncomeAmount = 200; // 每 60 秒 200 金币
  static const int timedIncomeInterval = 60; // 秒

  // 金币加成
  double goldBonusPercent = 0.0; // 百分比加成
  int goldBonusFlat = 0; // 固定加成

  /// 获取金币
  void earnGold(int amount, GoldSource source, {String? description}) {
    // 应用加成
    int finalAmount = amount;
    if (source != GoldSource.interest) { // 利息不享受加成
      finalAmount = (amount * (1 + goldBonusPercent)).round() + goldBonusFlat;
    }

    gold += finalAmount;
    totalEarned += finalAmount;
    history.add(GoldRecord(
      amount: finalAmount,
      source: source,
      description: description,
    ));
  }

  /// 消耗金币
  bool spendGold(int amount, {String? description}) {
    if (gold >= amount) {
      gold -= amount;
      totalSpent += amount;
      history.add(GoldRecord(
        amount: -amount,
        source: GoldSource.other,
        description: description ?? '消费',
      ));
      return true;
    }
    return false;
  }

  /// 计算利息
  int calculateInterest() {
    int units = gold ~/ interestInterval;
    int interest = units * interestPerUnit;
    return interest.clamp(0, interestCap);
  }

  /// 发放利息
  void distributeInterest() {
    final interest = calculateInterest();
    if (interest > 0) {
      earnGold(interest, GoldSource.interest, description: '利息收入');
    }
  }

  /// 定时收入
  void distributeTimedIncome() {
    earnGold(timedIncomeAmount, GoldSource.timedIncome, description: '定时收入');
  }

  /// 设置金币加成
  void setGoldBonus({double percent = 0.0, int flat = 0}) {
    goldBonusPercent = percent;
    goldBonusFlat = flat;
  }

  /// 重置 (新游戏)
  void reset() {
    gold = 0;
    totalEarned = 0;
    totalSpent = 0;
    history = [];
    goldBonusPercent = 0.0;
    goldBonusFlat = 0;
  }

  /// 从 JSON 创建
  factory GoldSystem.fromJson(Map<String, dynamic> json) {
    final system = GoldSystem();
    system.gold = json['gold'] as int;
    system.totalEarned = json['totalEarned'] as int;
    system.totalSpent = json['totalSpent'] as int;
    system.goldBonusPercent = (json['goldBonusPercent'] as num?)?.toDouble() ?? 0.0;
    system.goldBonusFlat = json['goldBonusFlat'] as int? ?? 0;
    return system;
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      'gold': gold,
      'totalEarned': totalEarned,
      'totalSpent': totalSpent,
      'goldBonusPercent': goldBonusPercent,
      'goldBonusFlat': goldBonusFlat,
    };
  }
}
