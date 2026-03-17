import 'package:flutter/material.dart';
import '../models/enemy.dart';

/// 敌人显示组件
class EnemyWidget extends StatelessWidget {
  final Enemy enemy;
  final double size;

  const EnemyWidget({
    super.key,
    required this.enemy,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: enemy.isDead ? 0.3 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Color(enemy.colorValue).withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(enemy.colorValue),
            width: 2,
          ),
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
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    enemy.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'LV.${enemy.level}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
            
            // 血量条
            Positioned(
              bottom: 4,
              left: 4,
              right: 4,
              child: _buildHpBar(),
            ),
            
            // 状态效果
            if (enemy.isStunned)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '💫',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            
            if (enemy.isEnraged)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '😡',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHpBar() {
    double hpPercent = enemy.hp / enemy.maxHp;
    Color hpColor = hpPercent > 0.5 ? Colors.green : hpPercent > 0.25 ? Colors.orange : Colors.red;
    
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: hpPercent,
            backgroundColor: Colors.red.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(hpColor),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${enemy.hp}/${enemy.maxHp}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
