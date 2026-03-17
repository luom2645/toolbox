import 'enemy.dart';

/// 战斗逻辑提供者
class BattleProvider {
  /// 生成关卡敌人
  List<Enemy> spawnEnemies(int level, int count) {
    final enemies = <Enemy>[];
    final random = DateTime.now().millisecondsSinceEpoch;
    
    for (int i = 0; i < count; i++) {
      // 在 4x4 网格中随机位置生成敌人
      final x = (random + i) % 4;
      final y = ((random + i) ~/ 4) % 4;
      
      enemies.add(Enemy.createForLevel(level, i, x, y));
    }
    
    return enemies;
  }

  /// 计算战斗伤害
  BattleResult calculateBattle(Tile tile, Enemy enemy) {
    final skill = HeroSkill.getSkill(tile.value, enemy.x, enemy.y);
    int damage = HeroSkill.calculateDamage(tile.value, enemy, skill);
    
    // 暴击判定 (10% 概率)
    final isCrit = DateTime.now().millisecondsSinceEpoch % 10 == 0;
    if (isCrit) {
      damage = (damage * 1.5).round();
    }
    
    // 敌人受到伤害
    final actualDamage = enemy.takeDamage(damage);
    
    // 计算敌人反击伤害
    int enemyDamage = 0;
    if (!enemy.isDead && !enemy.isStunned) {
      enemyDamage = enemy.attack;
      
      // 狂暴加成
      if (enemy.isEnraged) {
        enemyDamage = (enemyDamage * 1.5).round();
      }
    }
    
    return BattleResult(
      isVictory: enemy.isDead,
      damageDealt: actualDamage > 0 ? actualDamage : damage,
      damageTaken: enemyDamage,
      skillUsed: skill.type != SkillType.none ? [skill.description] : [],
      hasCriticalHit: isCrit,
    );
  }

  /// 敌人回合
  GameState enemyTurn(GameState state) {
    int totalDamage = 0;
    
    for (final enemy in state.enemies) {
      if (!enemy.isDead && !enemy.isStunned) {
        totalDamage += enemy.attack;
        
        // 狂暴加成
        if (enemy.isEnraged) {
          totalDamage = (totalDamage * 1.5).round();
        }
      }
    }
    
    if (totalDamage > 0) {
      state = state.takeDamage(totalDamage);
    }
    
    // 更新敌人状态
    final updatedEnemies = <Enemy>[];
    for (final enemy in state.enemies) {
      if (enemy.isStunned) {
        enemy.stunTurns--;
        if (enemy.stunTurns <= 0) {
          enemy.isStunned = false;
        }
      }
      updatedEnemies.add(enemy);
    }
    
    return state.copyWith(enemies: updatedEnemies);
  }

  /// 检查战斗是否结束
  BattleResult? checkBattleEnd(GameState state) {
    // 玩家死亡
    if (state.playerHp <= 0) {
      return BattleResult(
        isVictory: false,
        damageDealt: state.score,
        damageTaken: state.playerMaxHp - state.playerHp,
      );
    }
    
    // 所有敌人死亡
    if (!state.hasEnemies()) {
      return BattleResult(
        isVictory: true,
        damageDealt: state.score,
        damageTaken: state.playerMaxHp - state.playerHp,
        goldEarned: state.gold,
        expEarned: state.level * 10,
      );
    }
    
    return null;
  }

  /// 应用 AOE 伤害
  List<Enemy> applyAOEDamage(List<Enemy> enemies, int centerX, int centerY, int damage) {
    return enemies.map((enemy) {
      // 计算与中心的距离
      final distance = ((enemy.x - centerX).abs() + (enemy.y - centerY).abs());
      
      // 3x3 范围内 (距离<=1)
      if (distance <= 1) {
        enemy.takeDamage(damage);
      }
      
      return enemy;
    }).where((e) => !e.isDead).toList();
  }
}
