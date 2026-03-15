import 'tile.dart';
import 'enemy.dart';

/// 游戏状态枚举
enum GameStatus {
  playing,
  won,
  lost,
  victory,    // 战斗胜利
  defeated,   // 战斗失败
}

/// 游戏模式
enum GameMode {
  classic,    // 经典模式
  story,      // 剧情模式
  tower,      // 无尽塔
  pvp,        // PVP 对战
}

/// 游戏状态管理
class GameState {
  final List<Tile> tiles;
  final List<Enemy> enemies;
  final int score;
  final int bestScore;
  final int gold;
  final int level;
  final GameStatus status;
  final GameMode mode;
  final int moveCount;
  final int combo;
  final int playerHp;
  final int playerMaxHp;

  GameState({
    required this.tiles,
    this.enemies = const [],
    this.score = 0,
    this.bestScore = 0,
    this.gold = 0,
    this.level = 1,
    this.status = GameStatus.playing,
    this.mode = GameMode.classic,
    this.moveCount = 0,
    this.combo = 0,
    this.playerHp = 100,
    this.playerMaxHp = 100,
  });

  /// 创建初始游戏状态
  factory GameState.initial([GameMode mode = GameMode.classic]) {
    return GameState(
      tiles: [],
      enemies: [],
      score: 0,
      bestScore: 0,
      gold: 0,
      level: mode == GameMode.classic ? 0 : 1,
      status: GameStatus.playing,
      mode: mode,
      moveCount: 0,
      combo: 0,
      playerHp: 100,
      playerMaxHp: 100,
    );
  }

  /// 复制并修改
  GameState copyWith({
    List<Tile>? tiles,
    List<Enemy>? enemies,
    int? score,
    int? bestScore,
    int? gold,
    int? level,
    GameStatus? status,
    GameMode? mode,
    int? moveCount,
    int? combo,
    int? playerHp,
    int? playerMaxHp,
  }) {
    return GameState(
      tiles: tiles ?? this.tiles,
      enemies: enemies ?? this.enemies,
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      gold: gold ?? this.gold,
      level: level ?? this.level,
      status: status ?? this.status,
      mode: mode ?? this.mode,
      moveCount: moveCount ?? this.moveCount,
      combo: combo ?? this.combo,
      playerHp: playerHp ?? this.playerHp,
      playerMaxHp: playerMaxHp ?? this.playerMaxHp,
    );
  }

  /// 获取指定位置的方块
  Tile? getTileAt(int x, int y) {
    try {
      return tiles.firstWhere((tile) => tile.x == x && tile.y == y);
    } catch (e) {
      return null;
    }
  }

  /// 检查是否为空位置
  bool isEmptyAt(int x, int y) {
    return !tiles.any((tile) => tile.x == x && tile.y == y);
  }

  /// 获取所有空位置
  List<MapEntry<int, int>> getEmptyPositions() {
    final positions = <MapEntry<int, int>>[];
    for (var x = 0; x < 4; x++) {
      for (var y = 0; y < 4; y++) {
        if (isEmptyAt(x, y)) {
          positions.add(MapEntry(x, y));
        }
      }
    }
    return positions;
  }

  /// 检查是否可以移动
  bool canMove() {
    if (getEmptyPositions().isNotEmpty) return true;
    
    // 检查是否有可合并的相邻方块
    for (final tile in tiles) {
      // 检查右侧
      final right = getTileAt(tile.x + 1, tile.y);
      if (right != null && right.value == tile.value) return true;
      
      // 检查下方
      final below = getTileAt(tile.x, tile.y + 1);
      if (below != null && below.value == tile.value) return true;
    }
    
    return false;
  }

  /// 检查是否获胜 (达到 2048)
  bool hasWon() {
    return tiles.any((tile) => tile.value >= 2048);
  }

  /// 检查是否还有敌人
  bool hasEnemies() {
    return enemies.any((e) => !e.isDead);
  }

  /// 获取存活敌人数量
  int get aliveEnemyCount => enemies.where((e) => !e.isDead).length;

  /// 玩家受到伤害
  GameState takeDamage(int damage) {
    final newHp = playerHp - damage;
    return copyWith(
      playerHp: newHp,
      status: newHp <= 0 ? GameStatus.defeated : status,
    );
  }

  /// 玩家治疗
  GameState heal(int amount) {
    final newHp = (playerHp + amount).clamp(0, playerMaxHp);
    return copyWith(playerHp: newHp);
  }

  /// 添加金币
  GameState addGold(int amount) {
    return copyWith(gold: gold + amount);
  }
}
