import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/game_state.dart';

/// 存档数据模型
class SaveData {
  final int score;
  final int bestScore;
  final int gold;
  final int level;
  final GameMode mode;
  final DateTime lastPlayed;

  SaveData({
    required this.score,
    required this.bestScore,
    required this.gold,
    required this.level,
    required this.mode,
    required this.lastPlayed,
  });

  /// 从 GameState 创建
  factory SaveData.fromGameState(GameState state) {
    return SaveData(
      score: state.score,
      bestScore: state.bestScore,
      gold: state.gold,
      level: state.level,
      mode: state.mode,
      lastPlayed: DateTime.now(),
    );
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'bestScore': bestScore,
      'gold': gold,
      'level': level,
      'mode': mode.index,
      'lastPlayed': lastPlayed.toIso8601String(),
    };
  }

  /// 从 JSON 解析
  factory SaveData.fromJson(Map<String, dynamic> json) {
    return SaveData(
      score: json['score'] ?? 0,
      bestScore: json['bestScore'] ?? 0,
      gold: json['gold'] ?? 0,
      level: json['level'] ?? 1,
      mode: GameMode.values[json['mode'] ?? 0],
      lastPlayed: json['lastPlayed'] != null
          ? DateTime.parse(json['lastPlayed'])
          : DateTime.now(),
    );
  }
}

/// 本地存档服务
class SaveService {
  static final SaveService _instance = SaveService._internal();
  factory SaveService() => _instance;
  SaveService._internal();

  static const String _fileName = 'game_save.json';
  File? _saveFile;

  /// 初始化存档服务
  Future<void> initialize() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _saveFile = File('${dir.path}/$_fileName');
      
      // 如果文件不存在，创建它
      if (!await _saveFile!.exists()) {
        await _saveFile!.create();
      }
    } catch (e) {
      print('存档服务初始化失败：$e');
    }
  }

  /// 保存游戏进度
  Future<bool> save(SaveData data) async {
    try {
      if (_saveFile == null) {
        print('存档文件未初始化');
        return false;
      }

      final jsonStr = jsonEncode(data.toJson());
      await _saveFile!.writeAsString(jsonStr);
      print('✅ 游戏已保存');
      return true;
    } catch (e) {
      print('❌ 保存失败：$e');
      return false;
    }
  }

  /// 读取存档
  Future<SaveData?> load() async {
    try {
      if (_saveFile == null || !await _saveFile!.exists()) {
        return null;
      }

      final jsonStr = await _saveFile!.readAsString();
      if (jsonStr.isEmpty) {
        return null;
      }

      final jsonMap = jsonDecode(jsonStr);
      return SaveData.fromJson(jsonMap);
    } catch (e) {
      print('❌ 读取存档失败：$e');
      return null;
    }
  }

  /// 删除存档
  Future<bool> delete() async {
    try {
      if (_saveFile != null && await _saveFile!.exists()) {
        await _saveFile!.writeAsString('');
        print('🗑️ 存档已删除');
      }
      return true;
    } catch (e) {
      print('❌ 删除存档失败：$e');
      return false;
    }
  }

  /// 检查是否有存档
  Future<bool> hasSave() async {
    try {
      if (_saveFile == null || !await _saveFile!.exists()) {
        return false;
      }

      final content = await _saveFile!.readAsString();
      return content.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// 获取存档信息 (不加载完整数据)
  Future<SaveData?> getSaveInfo() async {
    return await load();
  }
}
