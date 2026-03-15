import 'package:flutter/material.dart';
import '../models/game_state.dart';

/// 游戏结束/胜利弹窗
class GameOverDialog extends StatelessWidget {
  final GameStatus status;
  final int score;
  final int bestScore;
  final int level;
  final int gold;
  final VoidCallback? onRetry;
  final VoidCallback? onContinue;
  final VoidCallback? onMainMenu;

  const GameOverDialog({
    super.key,
    required this.status,
    required this.score,
    required this.bestScore,
    this.level = 1,
    this.gold = 0,
    this.onRetry,
    this.onContinue,
    this.onMainMenu,
  });

  @override
  Widget build(BuildContext context) {
    final isVictory = status == GameStatus.victory || status == GameStatus.won;
    final isDefeated = status == GameStatus.defeated || status == GameStatus.lost;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isVictory
                ? [Colors.amber.withOpacity(0.9), Colors.orange.withOpacity(0.8)]
                : isDefeated
                    ? [Colors.red.withOpacity(0.9), Colors.deepPurple.withOpacity(0.8)]
                    : [Colors.blue.withOpacity(0.9), Colors.teal.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isVictory ? Colors.yellow : isDefeated ? Colors.red : Colors.blue,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: (isVictory ? Colors.amber : Colors.red).withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 结果图标
            _buildResultIcon(isVictory, isDefeated),
            const SizedBox(height: 16),

            // 结果标题
            _buildTitle(isVictory, isDefeated),
            const SizedBox(height: 8),

            // 副标题
            _buildSubtitle(isVictory, isDefeated),
            const SizedBox(height: 24),

            // 统计信息
            _buildStats(),
            const SizedBox(height: 24),

            // 按钮
            _buildButtons(isVictory, isDefeated, context),
          ],
        ),
      ),
    );
  }

  Widget _buildResultIcon(bool isVictory, bool isDefeated) {
    String emoji;
    double size = 80;

    if (status == GameStatus.won) {
      emoji = '🏆'; // 经典模式胜利
    } else if (status == GameStatus.victory) {
      emoji = '⚔️'; // 战斗胜利
    } else if (status == GameStatus.lost) {
      emoji = '😢'; // 经典模式失败
    } else {
      emoji = '💀'; // 战斗失败
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: Text(
        emoji,
        style: TextStyle(fontSize: size),
      ),
    );
  }

  Widget _buildTitle(bool isVictory, bool isDefeated) {
    String title;
    Color color;

    if (status == GameStatus.won) {
      title = '恭喜通关！';
      color = Colors.yellow;
    } else if (status == GameStatus.victory) {
      title = '战斗胜利！';
      color = Colors.amber;
    } else if (status == GameStatus.lost) {
      title = '游戏结束';
      color = Colors.white70;
    } else {
      title = '战斗失败';
      color = Colors.red;
    }

    return Text(
      title,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: color,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(2, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(bool isVictory, bool isDefeated) {
    String subtitle;

    if (status == GameStatus.won) {
      subtitle = '你成功合成了 2048！';
    } else if (status == GameStatus.victory) {
      subtitle = '击败了所有敌人！';
    } else if (status == GameStatus.lost) {
      subtitle = '无法继续移动了';
    } else {
      subtitle = '英雄倒下了...';
    }

    return Text(
      subtitle,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildStatRow('📊 得分', '$score', score >= bestScore ? Colors.amber : Colors.white),
          if (score >= bestScore && status != GameStatus.playing) ...[
            const SizedBox(height: 8),
            const Text(
              '✨ 新纪录！',
              style: TextStyle(
                fontSize: 14,
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          const SizedBox(height: 8),
          _buildStatRow('🏅 最高分', '$bestScore', Colors.white70),
          if (level > 0) ...[
            const SizedBox(height: 8),
            _buildStatRow('📖 关卡', 'Lv.$level', Colors.cyan),
          ],
          if (gold > 0) ...[
            const SizedBox(height: 8),
            _buildStatRow('💰 金币', '$gold', Colors.orange),
          ],
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(bool isVictory, bool isDefeated, BuildContext context) {
    return Column(
      children: [
        // 继续按钮 (仅战斗胜利时显示)
        if (status == GameStatus.victory && onContinue != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onContinue!();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                '继续冒险',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // 重试按钮
        if (onRetry != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onRetry!();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isVictory ? Colors.green : Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                status == GameStatus.won ? '继续挑战' : '重新开始',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        const SizedBox(height: 12),

        // 返回主菜单按钮
        if (onMainMenu != null)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                onMainMenu!();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                '返回主菜单',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
