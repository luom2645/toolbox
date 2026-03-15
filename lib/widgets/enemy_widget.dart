import 'package:flutter/material.dart';
import '../models/enemy.dart';

/// 敌人显示组件
class EnemyWidget extends StatelessWidget {
  final Enemy enemy;
  final double size;

  const EnemyWidget({
    super.key,
    required this.enemy,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    if (enemy.isDead) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('💀', style: TextStyle(fontSize: 24)),
        ),
      );
    }

    final hpPercent = enemy.hp / enemy.maxHp;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(enemy.colorValue),
        borderRadius: BorderRadius.circular(12),
        border: enemy.isStunned
            ? Border.all(color: Colors.cyan, width: 3)
            : null,
        boxShadow: enemy.isEnraged
            ? [
                BoxShadow(
                  color: Colors.red.withOpacity(0.6),
                  blurRadius: 10,
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          // 敌人图标和名称
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  enemy.icon,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 2),
                // 等级
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'LV.${enemy.level}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 血量条
          Positioned(
            left: 4,
            right: 4,
            bottom: 4,
            child: _buildHealthBar(hpPercent),
          ),

          // 状态效果
          if (enemy.isStunned)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.cyan,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '💫',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),

          // 狂暴标识
          if (enemy.isEnraged)
            Positioned(
              left: 2,
              top: 2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '💢',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHealthBar(double hpPercent) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: [
          // 背景
          Container(
            height: 6,
            color: Colors.grey[800],
          ),
          // 血量
          FractionallySizedBox(
            widthFactor: hpPercent,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: hpPercent > 0.5
                      ? [Colors.green, Colors.lightGreen]
                      : hpPercent > 0.25
                          ? [Colors.orange, Colors.yellow]
                          : [Colors.red, Colors.deepOrange],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
