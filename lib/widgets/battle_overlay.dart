import 'package:flutter/material.dart';
import '../models/enemy.dart';
import '../models/battle_result.dart';
import 'enemy_widget.dart';
import 'damage_text.dart';

/// 战斗覆盖层 - 显示战斗信息和结果
class BattleOverlay extends StatelessWidget {
  final BattleResult? result;
  final List<Enemy> enemies;
  final int playerHp;
  final int playerMaxHp;
  final VoidCallback? onContinue;

  const BattleOverlay({
    super.key,
    this.result,
    required this.enemies,
    required this.playerHp,
    required this.playerMaxHp,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: result == null,
      child: AnimatedOpacity(
        opacity: result != null ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: result != null ? _buildResultPanel(context) : null,
        ),
      ),
    );
  }

  Widget _buildResultPanel(BuildContext context) {
    final isVictory = result!.isVictory;

    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isVictory ? Colors.amber : Colors.red,
            width: 2,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 350),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 结果图标
              Text(
                isVictory ? '🎉' : '💀',
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),

              // 结果标题
              Text(
                isVictory ? '战斗胜利！' : '战斗失败',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isVictory ? Colors.amber : Colors.red,
                ),
              ),
              const SizedBox(height: 8),

              // 战斗信息
              Text(
                result!.message,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // 统计信息
              if (isVictory) ...[
                _buildStatRow('造成伤害', '${result!.damageDealt}', Colors.orange),
                const SizedBox(height: 8),
                _buildStatRow('获得金币', '+${result!.goldEarned}', Colors.amber),
                const SizedBox(height: 8),
                _buildStatRow('获得经验', '+${result!.expEarned}', Colors.cyan),
              ] else ...[
                _buildStatRow('受到伤害', '${result!.damageTaken}', Colors.red),
              ],
              const SizedBox(height: 24),

              // 技能使用记录
              if (result!.skillUsed.isNotEmpty) ...[
                const Text(
                  '技能释放:',
                  style: TextStyle(fontSize: 14, color: Colors.white54),
                ),
                const SizedBox(height: 8),
                ...result!.skillUsed.map((skill) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    )),
                const SizedBox(height: 24),
              ],

              // 继续按钮
              if (onContinue != null)
                ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isVictory ? Colors.amber : Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    isVictory ? '继续冒险' : '重新开始',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
