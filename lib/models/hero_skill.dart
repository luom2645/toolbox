import 'enemy.dart';

/// 技能类型
enum SkillType {
  none,          // 无技能
  bash,          // 重击
  charge,        // 冲锋
  shieldBash,    // 盾击
  whirlwind,     // 剑刃风暴
  pressure,      // 王者威压
  godMode,       // 战神降临
  divineWrath,   // 天神之怒
  genesis,       // 创世一击
  domination,    // 数字统治
}

/// 技能效果
class SkillEffect {
  final SkillType type;
  final int damage;
  final String description;
  final Function? effectFunc;

  SkillEffect({
    required this.type,
    required this.damage,
    required this.description,
    this.effectFunc,
  });
}

/// 英雄技能管理器
class HeroSkill {
  /// 获取对应数字的技能
  static SkillEffect getSkill(int value, int targetX, int targetY) {
    if (value <= 4) {
      return SkillEffect(
        type: SkillType.none,
        damage: value,
        description: '普通攻击',
      );
    }

    switch (value) {
      case 8:
        return SkillEffect(
          type: SkillType.bash,
          damage: value * 2,
          description: '重击：造成双倍伤害并击退敌人',
        );

      case 16:
        return SkillEffect(
          type: SkillType.charge,
          damage: value * 2,
          description: '冲锋：穿透直线上的所有敌人',
        );

      case 32:
        return SkillEffect(
          type: SkillType.shieldBash,
          damage: value * 2,
          description: '盾击：眩晕敌人 2 回合',
        );

      case 64:
        return SkillEffect(
          type: SkillType.whirlwind,
          damage: value,
          description: '剑刃风暴：对 3×3 范围内所有敌人造成伤害',
        );

      case 128:
        return SkillEffect(
          type: SkillType.pressure,
          damage: value,
          description: '王者威压：全场敌人减速 50%',
        );

      case 256:
        return SkillEffect(
          type: SkillType.godMode,
          damage: value * 3,
          description: '战神降临：无敌 1 回合，伤害×3',
        );

      case 512:
        return SkillEffect(
          type: SkillType.divineWrath,
          damage: 9999,
          description: '天神之怒：秒杀所有≤256 的敌人',
        );

      case 1024:
        return SkillEffect(
          type: SkillType.genesis,
          damage: 9999,
          description: '创世一击：秒杀所有≤512 的敌人',
        );

      case 2048:
      default:
        return SkillEffect(
          type: SkillType.domination,
          damage: 99999,
          description: '数字统治：清除全场所有敌人',
        );
    }
  }

  /// 计算技能伤害
  static int calculateDamage(int value, Enemy enemy, SkillEffect skill) {
    // 秒杀技能
    if (skill.type == SkillType.divineWrath && enemy.type.index <= EnemyType.orc.index) {
      return 9999;
    }
    if (skill.type == SkillType.genesis && enemy.type.index <= EnemyType.darkKnight.index) {
      return 9999;
    }
    if (skill.type == SkillType.domination) {
      return 99999;
    }

    // 普通技能伤害
    return skill.damage;
  }

  /// 获取技能图标
  static String getSkillIcon(SkillType type) {
    switch (type) {
      case SkillType.none:
        return '⚔️';
      case SkillType.bash:
        return '💥';
      case SkillType.charge:
        return '💨';
      case SkillType.shieldBash:
        return '🛡️';
      case SkillType.whirlwind:
        return '🌪️';
      case SkillType.pressure:
        return '👑';
      case SkillType.godMode:
        return '⚡';
      case SkillType.divineWrath:
        return '🔥';
      case SkillType.genesis:
        return '✨';
      case SkillType.domination:
        return '👑';
    }
  }
}
