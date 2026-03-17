import 'package:flutter/material.dart';
import '../models/settings.dart';

/// 设置服务 - 管理游戏设置
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  Settings _settings = Settings();

  /// 获取设置
  Settings get settings => _settings;

  /// 初始化设置
  Future<void> initialize() async {
    // TODO: 从本地存储加载设置
    _settings = Settings();
  }

  /// 保存设置
  Future<void> saveSettings() async {
    // TODO: 保存到本地存储
    print('设置已保存');
  }

  /// 切换静音
  Future<void> toggleMute() async {
    _settings = _settings.copyWith(isMuted: !_settings.isMuted);
    await saveSettings();
  }

  /// 设置 BGM 音量
  Future<void> setBGMVolume(double volume) async {
    _settings = _settings.copyWith(bgmVolume: volume.clamp(0.0, 1.0));
    await saveSettings();
  }

  /// 设置音效音量
  Future<void> setSFXVolume(double volume) async {
    _settings = _settings.copyWith(sfxVolume: volume.clamp(0.0, 1.0));
    await saveSettings();
  }

  /// 切换粒子效果
  Future<void> toggleParticles() async {
    _settings = _settings.copyWith(enableParticles: !_settings.enableParticles);
    await saveSettings();
  }

  /// 切换战斗动画
  Future<void> toggleBattleAnimation() async {
    _settings =
        _settings.copyWith(enableBattleAnimation: !_settings.enableBattleAnimation);
    await saveSettings();
  }

  /// 重置设置
  Future<void> resetSettings() async {
    _settings = Settings();
    await saveSettings();
  }
}
