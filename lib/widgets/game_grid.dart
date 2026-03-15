import 'package:flutter/material.dart';
import '../models/tile.dart';
import '../models/enemy.dart';
import '../providers/game_provider.dart';
import 'enemy_widget.dart';
import 'damage_text.dart';

/// 游戏网格组件 (含战斗系统)
class GameGrid extends StatefulWidget {
  final List<Tile> tiles;
  final List<Enemy> enemies;
  final Function(Direction) onMove;

  const GameGrid({
    super.key,
    required this.tiles,
    required this.enemies,
    required this.onMove,
  });

  @override
  State<GameGrid> createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {
  Offset _startPan = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanEnd: _onPanEnd,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.deepPurple.withOpacity(0.5),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            // 背景网格
            _buildBackgroundGrid(),
            
            // 敌人 (在底层)
            ...widget.enemies.where((e) => !e.isDead).map((enemy) => _buildEnemy(enemy)),
            
            // 方块 (在上层)
            ...widget.tiles.map((tile) => _buildTile(tile)),
          ],
        ),
      ),
    );
  }

  Widget _buildEnemy(Enemy enemy) {
    final cellSize = (MediaQuery.of(context).size.width - 64) / 4;
    final spacing = 8.0;
    
    return Positioned(
      left: spacing + enemy.x * (cellSize + spacing),
      top: spacing + enemy.y * (cellSize + spacing),
      child: EnemyWidget(
        enemy: enemy,
        size: cellSize,
      ),
    );
  }

  Widget _buildBackgroundGrid() {
    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(16, (index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }

  Widget _buildTile(Tile tile) {
    final cellSize = (MediaQuery.of(context).size.width - 64) / 4;
    final spacing = 8.0;
    
    return Positioned(
      left: spacing + tile.x * (cellSize + spacing),
      top: spacing + tile.y * (cellSize + spacing),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: cellSize,
        height: cellSize,
        child: _TileWidget(tile: tile),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _startPan = details.globalPosition;
  }

  void _onPanEnd(DragEndDetails details) {
    final endPosition = details.globalPosition;
    final dx = endPosition.dx - _startPan.dx;
    final dy = endPosition.dy - _startPan.dy;

    // 判断滑动方向
    if (dx.abs() > dy.abs()) {
      // 水平滑动
      if (dx.abs() > 30) {
        widget.onMove(dx > 0 ? Direction.right : Direction.left);
      }
    } else {
      // 垂直滑动
      if (dy.abs() > 30) {
        widget.onMove(dy > 0 ? Direction.down : Direction.up);
      }
    }
  }
}

/// 单个方块组件
class _TileWidget extends StatelessWidget {
  final Tile tile;

  const _TileWidget({required this.tile});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: tile.isNew ? 1.2 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: Color(tile.colorValue),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color(tile.colorValue).withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 数字
              Text(
                tile.value.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: tile.value >= 1000 ? 20 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // 英雄名称 (小字)
              if (tile.value >= 64)
                Text(
                  tile.heroName,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
