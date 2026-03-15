import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// 设置数据模型
class SettingsData {
  double bgmVolume;
  double sfxVolume;
  bool isMuted;
  bool showDamageNumbers;
  bool enableParticles;

  SettingsData({
    this.bgmVolume = 0.5,
    this.sfxVolume = 0.7,
    this.isMuted = false,
    this.showDamageNumbers = true,
    this.enableParticles = true,
  });

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      'bgmVolume': bgmVolume,
      'sfxVolume': sfxVolume,
      'isMuted': isMuted,
      'showDamageNumbers': showDamageNumbers,
      'enableParticles': enableParticles,
    };
  }

  /// 从 JSON 解析
  factory SettingsData.fromJson(Map<String, dynamic> json) {
    return SettingsData(
      bgmVolume: (json['bgmVolume'] ?? 0.5).toDouble(),
      sfxVolume: (json['sfxVolume'] ?? 0.7).toDouble(),
      isMuted: json['isMuted'] ?? false,
      showDamageNumbers: json['showDamageNumbers'] ?? true,
      enableParticles: json['enableParticles'] ?? true,
    );
  }
}

/// 设置服务
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static const String _fileName = 'settings.json';
  File? _settingsFile;
  SettingsData? _cachedSettings;

  /// 初始化设置服务
  Future<void> initialize() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _settingsFile = File('${dir.path}/$_fileName');
      
      if (!await _settingsFile!.exists()) {
        await _settingsFile!.create();
      }
      
      // 加载缓存
      _cachedSettings = await _loadFromFile();
    } catch (e) {
      print('设置服务初始化失败：$e');
      _cachedSettings = SettingsData();
    }
  }

  /// 从文件加载
  Future<SettingsData> _loadFromFile() async {
    try {
      if (_settingsFile == null || !await _settingsFile!.exists()) {
        return SettingsData();
      }

      final jsonStr = await _settingsFile!.readAsString();
      if (jsonStr.isEmpty) {
        return SettingsData();
      }

      final jsonMap = jsonDecode(jsonStr);
      return SettingsData.fromJson(jsonMap);
    } catch (e) {
      print('加载设置失败：$e');
      return SettingsData();
    }
  }

  /// 保存到文件
  Future<bool> _saveToFile(SettingsData data) async {
    try {
      if (_settingsFile == null) return false;

      final jsonStr = jsonEncode(data.toJson());
      await _settingsFile!.writeAsString(jsonStr);
      return true;
    } catch (e) {
      print('保存设置失败：$e');
      return false;
    }
  }

  /// 获取设置
  SettingsData get settings {
    _cachedSettings ??= SettingsData();
    return _cachedSettings!;
  }

  /// 设置 BGM 音量
  Future<void> setBGMVolume(double volume) async {
    _cachedSettings ??= await _loadFromFile();
    _cachedSettings!.bgmVolume = volume.clamp(0.0, 1.0);
    await _saveToFile(_cachedSettings!);
  }

  /// 设置音效音量
  Future<void> setSFXVolume(double volume) async {
    _cachedSettings ??= await _loadFromFile();
    _cachedSettings!.sfxVolume = volume.clamp(0.0, 1.0);
    await _saveToFile(_cachedSettings!);
  }

  /// 切换静音
  Future<void> toggleMute() async {
    _cachedSettings ??= await _loadFromFile();
    _cachedSettings!.isMuted = !_cachedSettings!.isMuted;
    await _saveToFile(_cachedSettings!);
  }

  /// 设置静音
  Future<void> setMute(bool muted) async {
    _cachedSettings ??= await _loadFromFile();
    _cachedSettings!.isMuted = muted;
    await _saveToFile(_cachedSettings!);
  }

  /// 切换伤害数字显示
  Future<void> toggleDamageNumbers() async {
    _cachedSettings ??= await _loadFromFile();
    _cachedSettings!.showDamageNumbers = !_cachedSettings!.showDamageNumbers;
    await _saveToFile(_cachedSettings!);
  }

  /// 切换粒子效果
  Future<void> toggleParticles() async {
    _cachedSettings ??= await _loadFromFile();
    _cachedSettings!.enableParticles = !_cachedSettings!.enableParticles;
    await _saveToFile(_cachedSettings!);
  }

  /// 重置为默认值
  Future<void> resetToDefaults() async {
    _cachedSettings = SettingsData();
    await _saveToFile(_cachedSettings!);
  }
}
