import 'package:flutter/material.dart';
import '../models/tile.dart';
import '../models/enemy.dart';
import '../models/game_state.dart';
import '../models/battle_result.dart';
import '../models/hero_skill.dart';
import '../widgets/game_grid.dart'; // For Direction
import 'battle_provider.dart';
import 'dart:math';

/// 游戏逻辑提供者
class GameProvider extends ChangeNotifier {
  GameState _state = GameState.initial();
  final Random _random = Random();
  int _nextId = 1;
  final BattleProvider _battleProvider = BattleProvider();

  GameState get state => _state;
  int get score => _state.score;
  int get bestScore => _state.bestScore;
  GameStatus get status => _state.status;
  GameMode get mode => _state.mode;
  int get level => _state.level;
  int get gold => _state.gold;
  int get playerHp => _state.playerHp;
  int get playerMaxHp => _state.playerMaxHp;

  /// 开始新游戏
  void startNewGame([GameMode mode = GameMode.classic]) {
    _state = GameState.initial(mode);
    _addRandomTile();
    _addRandomTile();
    
    // 剧情模式/无尽塔生成敌人
    if (mode != GameMode.classic) {
      _spawnEnemiesForLevel(1);
    }
    
    notifyListeners();
  }

  /// 进入下一关
  void nextLevel() {
    final nextLevel = _state.level + 1;
    _state = _state.copyWith(
      level: nextLevel,
      tiles: [],
      enemies: [],
    );
    _addRandomTile();
    _addRandomTile();
    _spawnEnemiesForLevel(nextLevel);
    notifyListeners();
  }

  /// 生成关卡敌人
  void _spawnEnemiesForLevel(int level) {
    int enemyCount = (level / 5).ceil() + 1;
    if (enemyCount > 8) enemyCount = 8;
    
    _state = _state.copyWith(
      enemies: _battleProvider.spawnEnemies(level, enemyCount),
    );
  }

  /// 添加随机方块
  void _addRandomTile() {
    final emptyPositions = _state.getEmptyPositions();
    if (emptyPositions.isEmpty) return;

    final pos = emptyPositions[_random.nextInt(emptyPositions.length)];
    final value = _random.nextDouble() < 0.9 ? 2 : 4;

    _state.tiles.add(Tile(
      id: _nextId++,
      value: value,
      x: pos.key,
      y: pos.value,
      isNew: true,
    ));

    // 清除所有方块的 isNew 标记
    for (final tile in _state.tiles) {
      tile.isNew = false;
    }
  }

  /// 处理滑动
  void move(Direction direction) {
    if (_state.status != GameStatus.playing && _state.status != GameStatus.victory) return;

    final oldTiles = List<Tile>.from(_state.tiles);
    final oldEnemies = List<Enemy>.from(_state.enemies);
    final moved = _moveTiles(direction);

    if (moved) {
      _addRandomTile();
      
      // 战斗模式：检查碰撞和战斗
      if (_state.mode != GameMode.classic) {
        _handleCollisions(direction);
        
        // 敌人回合
        if (_state.hasEnemies() && _state.status == GameStatus.playing) {
          _state = _battleProvider.enemyTurn(_state);
        }
        
        // 检查战斗结果
        final battleResult = _battleProvider.checkBattleEnd(_state);
        if (battleResult != null) {
          if (battleResult.isVictory) {
            _state = _state.copyWith(
              status: GameStatus.victory,
              gold: _state.gold + battleResult.goldEarned,
              score: _state.score + battleResult.damageDealt,
            );
          } else {
            _state = _state.copyWith(status: GameStatus.defeated);
          }
        }
      }
      
      _state = _state.copyWith(
        moveCount: _state.moveCount + 1,
        combo: _state.combo + 1,
      );

      // 经典模式：检查游戏状态
      if (_state.mode == GameMode.classic) {
        if (_state.hasWon()) {
          _state = _state.copyWith(status: GameStatus.won);
        } else if (!_state.canMove()) {
          _state = _state.copyWith(status: GameStatus.lost);
        }
      }
    } else {
      _state = _state.copyWith(combo: 0);
    }

    notifyListeners();
  }

  /// 处理碰撞和战斗
  void _handleCollisions(Direction direction) {
    List<Enemy> updatedEnemies = List<Enemy>.from(_state.enemies);
    int totalDamage = 0;
    List<String> skillLogs = [];

    for (var tile in _state.tiles) {
      // 检查该方块移动路径上是否有敌人
      for (var enemy in updatedEnemies) {
        if (enemy.isDead) continue;

        bool willCollide = false;
        
        // 根据移动方向检查是否会碰撞
        switch (direction) {
          case Direction.up:
            if (tile.x == enemy.x && tile.y > enemy.y) willCollide = true;
            break;
          case Direction.down:
            if (tile.x == enemy.x && tile.y < enemy.y) willCollide = true;
            break;
          case Direction.left:
            if (tile.y == enemy.y && tile.x > enemy.x) willCollide = true;
            break;
          case Direction.right:
            if (tile.y == enemy.y && tile.x < enemy.x) willCollide = true;
            break;
        }

        if (willCollide) {
          // 发生战斗
          final result = _battleProvider.calculateBattle(tile, enemy);
          totalDamage += result.damageDealt;
          
          if (result.skillUsed.isNotEmpty) {
            skillLogs.addAll(result.skillUsed);
          }

          // 处理 AOE 技能
          if (result.damageDealt >= 64 && tile.value == 64) {
            updatedEnemies = _battleProvider.applyAOEDamage(
              updatedEnemies,
              enemy.x,
              enemy.y,
              tile.value,
            );
          }
        }
      }
    }

    // 移除死亡敌人
    updatedEnemies.removeWhere((e) => e.isDead);
    
    _state = _state.copyWith(
      enemies: updatedEnemies,
      score: _state.score + totalDamage,
    );
  }

  /// 执行移动逻辑
  bool _moveTiles(Direction direction) {
    bool moved = false;
    final tiles = _state.tiles;

    // 按移动方向排序
    tiles.sort((a, b) {
      switch (direction) {
        case Direction.up:
          return a.y - b.y;
        case Direction.down:
          return b.y - a.y;
        case Direction.left:
          return a.x - b.x;
        case Direction.right:
          return b.x - a.x;
      }
    });

    // 移动每个方块
    for (final tile in tiles) {
      final steps = _getMoveSteps(tile, direction);
      if (steps > 0) {
        moved = true;
        switch (direction) {
          case Direction.up:
            tile.y -= steps;
            break;
          case Direction.down:
            tile.y += steps;
            break;
          case Direction.left:
            tile.x -= steps;
            break;
          case Direction.right:
            tile.x += steps;
            break;
        }
      }
    }

    // 处理合并
    _mergeTiles(direction);

    return moved;
  }

  /// 获取可移动步数
  int _getMoveSteps(Tile tile, Direction direction) {
    int steps = 0;
    int x = tile.x;
    int y = tile.y;

    while (true) {
      int nextX = x;
      int nextY = y;

      switch (direction) {
        case Direction.up:
          nextY--;
          break;
        case Direction.down:
          nextY++;
          break;
        case Direction.left:
          nextX--;
          break;
        case Direction.right:
          nextX++;
          break;
      }

      if (nextX < 0 || nextX >= 4 || nextY < 0 || nextY >= 4) break;

      final other = _state.getTileAt(nextX, nextY);
      if (other == null) {
        x = nextX;
        y = nextY;
        steps++;
      } else if (other.value == tile.value && !other.isMerged) {
        x = nextX;
        y = nextY;
        steps++;
        break;
      } else {
        break;
      }
    }

    return steps;
  }

  /// 合并方块
  void _mergeTiles(Direction direction) {
    final tiles = _state.tiles;
    final mergedIds = <int>{};

    for (final tile in tiles) {
      if (mergedIds.contains(tile.id)) continue;

      Tile? mergeTarget;
      switch (direction) {
        case Direction.up:
          mergeTarget = _findMergeTarget(tile, 0, 1);
          break;
        case Direction.down:
          mergeTarget = _findMergeTarget(tile, 0, -1);
          break;
        case Direction.left:
          mergeTarget = _findMergeTarget(tile, 1, 0);
          break;
        case Direction.right:
          mergeTarget = _findMergeTarget(tile, -1, 0);
          break;
      }

      if (mergeTarget != null && !mergedIds.contains(mergeTarget.id)) {
        // 合并
        tile.value *= 2;
        tile.isMerged = true;
        _state.score += tile.value;
        
        // 移除被合并的方块
        tiles.remove(mergeTarget);
        mergedIds.add(tile.id);
      }
    }

    // 清除合并标记
    for (final tile in tiles) {
      tile.isMerged = false;
    }
  }

  Tile? _findMergeTarget(Tile tile, int dx, int dy) {
    final x = tile.x + dx;
    final y = tile.y + dy;
    
    if (x < 0 || x >= 4 || y < 0 || y >= 4) return null;
    
    final other = _state.getTileAt(x, y);
    if (other != null && other.value == tile.value && !other.isMerged) {
      return other;
    }
    return null;
  }

  /// 重置游戏
  void reset() {
    _state = GameState.initial();
    notifyListeners();
  }
}

/// 移动方向
enum Direction { up, down, left, right }
