import 'enemy.dart';
import 'treasure_monster.dart';

/// 战斗结果
class BattleResult {
  final bool isVictory;
  final int damageDealt;
  final int damageTaken;
  final int goldEarned;
  final int expEarned;
  final List<String> skillUsed;
  final bool hasCriticalHit;
  final int comboCount;

  BattleResult({
    required this.isVictory,
    required this.damageDealt,
    required this.damageTaken,
    this.goldEarned = 0,
    this.expEarned = 0,
    this.skillUsed = const [],
    this.hasCriticalHit = false,
    this.comboCount = 0,
  });

  BattleResult copyWith({
    bool? isVictory,
    int? damageDealt,
    int? damageTaken,
    int? goldEarned,
    int? expEarned,
    List<String>? skillUsed,
    bool? hasCriticalHit,
    int? comboCount,
  }) {
    return BattleResult(
      isVictory: isVictory ?? this.isVictory,
      damageDealt: damageDealt ?? this.damageDealt,
      damageTaken: damageTaken ?? this.damageTaken,
      goldEarned: goldEarned ?? this.goldEarned,
      expEarned: expEarned ?? this.expEarned,
      skillUsed: skillUsed ?? this.skillUsed,
      hasCriticalHit: hasCriticalHit ?? this.hasCriticalHit,
      comboCount: comboCount ?? this.comboCount,
    );
  }
}
