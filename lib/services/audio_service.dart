import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

/// 音效服务 - 管理游戏 BGM 和音效
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  
  bool _isMuted = false;
  double _bgmVolume = 0.5;
  double _sfxVolume = 0.7;

  /// 是否静音
  bool get isMuted => _isMuted;
  
  /// BGM 音量
  double get bgmVolume => _bgmVolume;
  
  /// 音效音量
  double get sfxVolume => _sfxVolume;

  /// 初始化音频服务
  Future<void> initialize() async {
    try {
      // 预加载音效
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(_bgmVolume);
      await _sfxPlayer.setVolume(_sfxVolume);
    } catch (e) {
      print('AudioService 初始化失败：$e');
    }
  }

  /// 播放 BGM
  Future<void> playBGM(String assetPath) async {
    if (_isMuted) return;
    
    try {
      // 检查文件是否存在
      final file = File(assetPath);
      if (!await file.exists()) {
        print('BGM 文件不存在：$assetPath');
        return;
      }
      
      await _bgmPlayer.play(DeviceFileSource(assetPath));
    } catch (e) {
      print('播放 BGM 失败：$e');
    }
  }

  /// 停止 BGM
  Future<void> stopBGM() async {
    try {
      await _bgmPlayer.stop();
    } catch (e) {
      print('停止 BGM 失败：$e');
    }
  }

  /// 暂停 BGM
  Future<void> pauseBGM() async {
    try {
      await _bgmPlayer.pause();
    } catch (e) {
      print('暂停 BGM 失败：$e');
    }
  }

  /// 恢复 BGM
  Future<void> resumeBGM() async {
    if (_isMuted) return;
    
    try {
      await _bgmPlayer.resume();
    } catch (e) {
      print('恢复 BGM 失败：$e');
    }
  }

  /// 播放音效
  Future<void> playSFX(String assetPath) async {
    if (_isMuted) return;
    
    try {
      final file = File(assetPath);
      if (!await file.exists()) {
        print('音效文件不存在：$assetPath');
        return;
      }
      
      await _sfxPlayer.play(DeviceFileSource(assetPath));
    } catch (e) {
      print('播放音效失败：$e');
    }
  }

  /// 播放滑动音效
  Future<void> playSlide() async {
    // 占位实现 - 实际使用时需要音效文件
    print('🎵 滑动音效');
  }

  /// 播放合并音效
  Future<void> playMerge(int value) async {
    // 根据合并的数字播放不同音调
    print('🎵 合并音效：$value');
  }

  /// 播放战斗音效
  Future<void> playBattle() async {
    print('⚔️ 战斗音效');
  }

  /// 播放胜利音效
  Future<void> playVictory() async {
    print('🎉 胜利音效');
  }

  /// 播放失败音效
  Future<void> playDefeat() async {
    print('💀 失败音效');
  }

  /// 切换静音
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    
    if (_isMuted) {
      await _bgmPlayer.pause();
      await _sfxPlayer.pause();
    } else {
      await _bgmPlayer.resume();
      await _bgmPlayer.setVolume(_bgmVolume);
      await _sfxPlayer.setVolume(_sfxVolume);
    }
  }

  /// 设置 BGM 音量
  Future<void> setBGMVolume(double volume) async {
    _bgmVolume = volume.clamp(0.0, 1.0);
    await _bgmPlayer.setVolume(_bgmVolume);
  }

  /// 设置音效音量
  Future<void> setSFXVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    await _sfxPlayer.setVolume(_sfxVolume);
  }

  /// 释放资源
  Future<void> dispose() async {
    try {
      await _bgmPlayer.dispose();
      await _sfxPlayer.dispose();
    } catch (e) {
      print('释放音频资源失败：$e');
    }
  }
}
