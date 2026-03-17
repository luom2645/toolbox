import 'package:flutter/material.dart';
import 'enemy_widget.dart';

/// 战斗覆盖层 - 显示玩家和敌人状态
class BattleOverlay extends StatelessWidget {
  final int playerHp;
  final int playerMaxHp;
  final int level;
  final int gold;
  final VoidCallback onClose;

  const BattleOverlay({
    super.key,
    required this.playerHp,
    required this.playerMaxHp,
    required this.level,
    required this.gold,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 玩家状态
            _buildPlayerStatus(),
            
            // 关卡信息
            _buildLevelInfo(),
            
            // 金币
            _buildGoldInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerStatus() {
    double hpPercent = playerHp / playerMaxHp;
    Color hpColor = hpPercent > 0.5 ? Colors.green : hpPercent > 0.25 ? Colors.orange : Colors.red;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$playerHp / $playerMaxHp',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                width: 100,
                height: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: hpPercent,
                    backgroundColor: Colors.red.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(hpColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('📖', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            '第 $level 关',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('💰', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            '$gold',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
