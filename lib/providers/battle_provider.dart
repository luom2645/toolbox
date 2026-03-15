import 'package:flutter/material.dart';
import '../models/tile.dart';
import '../models/enemy.dart';
import '../models/game_state.dart';
import '../models/battle_result.dart';
import '../models/hero_skill.dart';
import 'dart:math';

/// 战斗系统提供者
class BattleProvider extends ChangeNotifier {
  final Random _random = Random();

  /// 计算英雄撞击敌人的战斗
  BattleResult calculateBattle(Tile hero, Enemy enemy) {
    // 获取英雄技能
    final skill = HeroSkill.getSkill(hero.value, enemy.x, enemy.y);
    
    // 计算伤害
    int damage = HeroSkill.calculateDamage(hero.value, enemy, skill);
    
    // 敌人受到伤害
    int actualDamage = enemy.takeDamage(damage);
    
    // 记录使用的技能
    List<String> skillsUsed = [];
    if (skill.type != SkillType.none) {
      skillsUsed.add('${HeroSkill.getSkillIcon(skill.type)} ${skill.description}');
    }

    // 敌人死亡判定
    if (enemy.isDead) {
      // 计算奖励
      int goldReward = enemy.maxHp ~/ 5;
      int expReward = enemy.level * 10;
      
      // 史莱姆分裂
      if (enemy.type == EnemyType.slime && !enemy.hasRevived) {
        // 生成 2 个小史莱姆 (由外部处理)
      }

      return BattleResult.victory(
        damageDealt: actualDamage,
        goldEarned: goldReward,
        expEarned: expReward,
        skillUsed: skillsUsed,
      );
    }

    // 敌人反击
    int enemyDamage = enemy.attack;
    
    // 计算最终结果
    return BattleResult(
      isVictory: false,
      damageDealt: actualDamage,
      damageTaken: enemyDamage,
      message: '⚔️ 对${enemy.name}造成$actualDamage 点伤害，受到$enemyDamage 点反击伤害',
      skillUsed: skillsUsed,
    );
  }

  /// 处理 AOE 技能 (剑刃风暴)
  List<Enemy> applyAOEDamage(
    List<Enemy> enemies,
    int centerX,
    int centerY,
    int damage,
  ) {
    return enemies.map((enemy) {
      // 检查是否在 3x3 范围内
      int dx = (enemy.x - centerX).abs();
      int dy = (enemy.y - centerY).abs();
      
      if (dx <= 1 && dy <= 1) {
        enemy.takeDamage(damage);
      }
      return enemy;
    }).toList();
  }

  /// 处理冲锋技能 (穿透直线)
  List<Enemy> applyChargeDamage(
    List<Enemy> enemies,
    int startX,
    int startY,
    Direction direction,
    int damage,
  ) {
    return enemies.map((enemy) {
      bool hit = false;
      
      switch (direction) {
        case Direction.up:
          if (enemy.x == startX && enemy.y < startY) hit = true;
          break;
        case Direction.down:
          if (enemy.x == startX && enemy.y > startY) hit = true;
          break;
        case Direction.left:
          if (enemy.y == startY && enemy.x < startX) hit = true;
          break;
        case Direction.right:
          if (enemy.y == startY && enemy.x > startX) hit = true;
          break;
      }
      
      if (hit) {
        enemy.takeDamage(damage);
      }
      return enemy;
    }).toList();
  }

  /// 敌人回合行动
  GameState enemyTurn(GameState state) {
    int totalDamage = 0;
    
    for (var enemy in state.enemies) {
      if (enemy.isDead || enemy.isStunned) continue;
      
      // 简单的 AI：向最近的玩家方块移动
      // 这里简化为直接攻击
      totalDamage += enemy.attack;
    }
    
    return state.takeDamage(totalDamage);
  }

  /// 生成敌人 (根据关卡)
  List<Enemy> spawnEnemies(int level, int enemyCount) {
    List<Enemy> enemies = [];
    
    for (int i = 0; i < enemyCount; i++) {
      // 随机位置
      int x = _random.nextInt(4);
      int y = _random.nextInt(4);
      
      enemies.add(Enemy.createForLevel(level, i, x, y));
    }
    
    return enemies;
  }

  /// 检查战斗是否结束
  BattleResult? checkBattleEnd(GameState state) {
    // 玩家死亡
    if (state.playerHp <= 0) {
      return BattleResult.defeat(damageTaken: state.playerMaxHp);
    }
    
    // 所有敌人死亡
    if (!state.hasEnemies()) {
      int totalGold = state.gold;
      int totalExp = state.level * 20;
      
      return BattleResult.victory(
        damageDealt: state.score,
        goldEarned: totalGold,
        expEarned: totalExp,
        skillUsed: [],
      );
    }
    
    return null;
  }
}
