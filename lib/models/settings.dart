import 'package:flutter/material.dart';

/// 设置数据模型
class SettingsData {
  double bgmVolume;
  double sfxVolume;
  bool isMuted;
  bool showDamageNumbers;
  bool showBattleLog;
  int themeIndex;

  SettingsData({
    this.bgmVolume = 0.5,
    this.sfxVolume = 0.7,
    this.isMuted = false,
    this.showDamageNumbers = true,
    this.showBattleLog = true,
    this.themeIndex = 0,
  });

  /// 从 JSON 解析
  factory SettingsData.fromJson(Map<String, dynamic> json) {
    return SettingsData(
      bgmVolume: (json['bgmVolume'] ?? 0.5).toDouble(),
      sfxVolume: (json['sfxVolume'] ?? 0.7).toDouble(),
      isMuted: json['isMuted'] ?? false,
      showDamageNumbers: json['showDamageNumbers'] ?? true,
      showBattleLog: json['showBattleLog'] ?? true,
      themeIndex: json['themeIndex'] ?? 0,
    );
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      'bgmVolume': bgmVolume,
      'sfxVolume': sfxVolume,
      'isMuted': isMuted,
      'showDamageNumbers': showDamageNumbers,
      'showBattleLog': showBattleLog,
      'themeIndex': themeIndex,
    };
  }
}
