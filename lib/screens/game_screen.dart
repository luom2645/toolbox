import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_grid.dart';
import '../widgets/battle_overlay.dart';
import '../widgets/game_over_dialog.dart';
import '../models/game_state.dart';

/// 游戏主界面
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 顶部信息栏
                _buildHeader(context),
                
                // 游戏区域
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Consumer<GameProvider>(
                        builder: (context, provider, child) {
                          return GameGrid(
                            tiles: provider.state.tiles,
                            enemies: provider.state.enemies,
                            onMove: (direction) => provider.move(direction),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                
                // 底部控制栏
                _buildFooter(context),
              ],
            ),
            
            // 战斗覆盖层 (剧情模式/PVP)
            Consumer<GameProvider>(
              builder: (context, provider, child) {
                if (provider.mode != GameMode.classic) {
                  return Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: BattleOverlay(
                      playerHp: provider.playerHp,
                      playerMaxHp: provider.playerMaxHp,
                      level: provider.level,
                      gold: provider.gold,
                      onClose: () {},
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.deepPurple.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            children: [
              // 模式指示
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildModeBadge(provider.mode),
                  if (provider.mode != GameMode.classic) ...[
                    const SizedBox(width: 12),
                    _buildChip('LV.${provider.level}', Colors.amber),
                    const SizedBox(width: 8),
                    _buildChip('💰 ${provider.gold}', Colors.orange),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              // 分数行
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildScoreCard('分数', provider.score),
                  _buildScoreCard('最高分', provider.bestScore),
                  // 玩家血量 (战斗模式)
                  if (provider.mode != GameMode.classic)
                    _buildHpBar(provider.playerHp, provider.playerMaxHp),
                ],
              ),
              const SizedBox(height: 8),
              // 新游戏按钮
              IconButton.filled(
                onPressed: () => _showGameModeDialog(context, provider),
                icon: const Icon(Icons.menu),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeBadge(GameMode mode) {
    String text;
    Color color;
    switch (mode) {
      case GameMode.classic:
        text = '🎮 经典模式';
        color = Colors.blue;
        break;
      case GameMode.story:
        text = '📖 剧情模式';
        color = Colors.purple;
        break;
      case GameMode.tower:
        text = '♾️ 无尽塔';
        color = Colors.red;
        break;
      case GameMode.pvp:
        text = '⚔️ PVP 对战';
        color = Colors.orange;
        break;
    }
    return _buildChip(text, color);
  }

  Widget _buildChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHpBar(int hp, int maxHp) {
    double percent = hp / maxHp;
    Color color = percent > 0.5 ? Colors.green : percent > 0.25 ? Colors.orange : Colors.red;
    
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            '❤️ 生命值',
            style: TextStyle(fontSize: 10, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.red.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$hp / $maxHp',
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        // 游戏结束时自动显示弹窗
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.state.status == GameStatus.won ||
              provider.state.status == GameStatus.lost ||
              provider.state.status == GameStatus.victory ||
              provider.state.status == GameStatus.defeated) {
            _showGameOverDialog(context, provider);
          }
        });

        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 方向提示
              Text(
                '滑动屏幕或按方向键移动',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showGameOverDialog(BuildContext context, GameProvider provider) {
    final state = provider.state;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(
        status: state.status,
        score: state.score,
        bestScore: state.bestScore,
        level: state.level,
        gold: state.gold,
        onRetry: () {
          provider.startNewGame(state.mode);
        },
        onContinue: state.status == GameStatus.victory
            ? () {
                provider.nextLevel();
              }
            : null,
        onMainMenu: () {
          // 返回主菜单 (待实现)
          provider.reset();
        },
      ),
    );
  }

  void _showNewGameDialog(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新游戏'),
        content: const Text('确定要开始新游戏吗？当前进度将丢失。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              provider.startNewGame();
              Navigator.pop(context);
            },
            child: const Text('开始'),
          ),
        ],
      ),
    );
  }
}
