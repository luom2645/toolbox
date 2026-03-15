/// 战斗结果
class BattleResult {
  final bool isVictory;
  final int damageDealt;
  final int damageTaken;
  final int goldEarned;
  final int expEarned;
  final List<String> skillUsed;
  final String message;

  BattleResult({
    required this.isVictory,
    this.damageDealt = 0,
    this.damageTaken = 0,
    this.goldEarned = 0,
    this.expEarned = 0,
    this.skillUsed = const [],
    this.message = '',
  });

  /// 创建胜利结果
  factory BattleResult.victory({
    required int damageDealt,
    required int goldEarned,
    required int expEarned,
    required List<String> skillUsed,
  }) {
    return BattleResult(
      isVictory: true,
      damageDealt: damageDealt,
      goldEarned: goldEarned,
      expEarned: expEarned,
      skillUsed: skillUsed,
      message: '🎉 战斗胜利！获得 $goldEarned 金币，$expEarned 经验',
    );
  }

  /// 创建失败结果
  factory BattleResult.defeat({
    required int damageTaken,
  }) {
    return BattleResult(
      isVictory: false,
      damageTaken: damageTaken,
      message: '💀 战斗失败... 休整后再来挑战吧！',
    );
  }

  /// 创建平局结果
  factory BattleResult.draw() {
    return BattleResult(
      isVictory: false,
      message: '⚖️ 势均力敌，下次再战！',
    );
  }
}
