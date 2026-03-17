import 'package:flutter/material.dart';
import '../models/game_state.dart';

/// 游戏结束对话框
class GameOverDialog extends StatelessWidget {
  final GameStatus status;
  final int score;
  final int bestScore;
  final int level;
  final int gold;
  final VoidCallback onRetry;
  final VoidCallback? onContinue;
  final VoidCallback onMainMenu;

  const GameOverDialog({
    super.key,
    required this.status,
    required this.score,
    required this.bestScore,
    required this.level,
    required this.gold,
    required this.onRetry,
    this.onContinue,
    required this.onMainMenu,
  });

  @override
  Widget build(BuildContext context) {
    bool isVictory = status == GameStatus.won || status == GameStatus.victory;
    bool isDefeat = status == GameStatus.lost || status == GameStatus.defeated;
    
    String title;
    String subtitle;
    IconData icon;
    Color color;
    
    if (status == GameStatus.won) {
      title = '🎉 胜利!';
      subtitle = '你达到了 2048!';
      icon = Icons.emoji_events;
      color = Colors.amber;
    } else if (status == GameStatus.victory) {
      title = '⚔️ 战斗胜利!';
      subtitle = '击败了所有敌人';
      icon = Icons.shield;
      color = Colors.green;
    } else if (status == GameStatus.lost) {
      title = '💀 游戏结束';
      subtitle = '再接再厉!';
      icon = Icons.sentiment_dissatisfied;
      color = Colors.red;
    } else {
      title = '😞 战败';
      subtitle = '英雄，请重新振作!';
      icon = Icons.close;
      color = Colors.red;
    }
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade900,
              Colors.indigo.shade900,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 图标
            Icon(
              icon,
              size: 64,
              color: color,
            ),
            const SizedBox(height: 16),
            
            // 标题
            Text(
              title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            
            // 副标题
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            
            // 统计信息
            _buildStatRow('得分', score.toString()),
            if (score >= bestScore && bestScore > 0)
              _buildStatRow('✨ 新纪录!', bestScore.toString(), highlight: true),
            if (level > 1)
              _buildStatRow('关卡', '第 $level 关'),
            if (gold > 0)
              _buildStatRow('金币', '💰 $gold'),
            
            const SizedBox(height: 24),
            
            // 按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 返回主菜单
                OutlinedButton.icon(
                  onPressed: onMainMenu,
                  icon: const Icon(Icons.home),
                  label: const Text('主菜单'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.5)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                
                // 继续/重试
                if (onContinue != null)
                  FilledButton.icon(
                    onPressed: onContinue,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('下一关'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  )
                else
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('再来一次'),
                    style: FilledButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: highlight ? Colors.amber : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
