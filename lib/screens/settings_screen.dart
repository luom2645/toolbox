import 'package:flutter/material.dart';
import '../services/settings_service.dart';

/// 设置界面
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settings = SettingsService();
  
  double _bgmVolume = 0.5;
  double _sfxVolume = 0.7;
  bool _isMuted = false;
  bool _showDamageNumbers = true;
  bool _enableParticles = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = _settings.settings;
    setState(() {
      _bgmVolume = settings.bgmVolume;
      _sfxVolume = settings.sfxVolume;
      _isMuted = settings.isMuted;
      _showDamageNumbers = settings.showDamageNumbers;
      _enableParticles = settings.enableParticles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ 设置'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 音量设置
          _buildSectionTitle('🔊 音量设置'),
          _buildVolumeSlider(
            label: 'BGM 音量',
            icon: Icons.music_note,
            value: _bgmVolume,
            onChanged: (value) async {
              setState(() => _bgmVolume = value);
              await _settings.setBGMVolume(value);
            },
          ),
          _buildVolumeSlider(
            label: '音效音量',
            icon: Icons.graphic_eq,
            value: _sfxVolume,
            onChanged: (value) async {
              setState(() => _sfxVolume = value);
              await _settings.setSFXVolume(value);
            },
          ),
          SwitchListTile(
            title: const Text('静音'),
            subtitle: const Text('关闭所有声音'),
            secondary: const Icon(Icons.volume_off),
            value: _isMuted,
            onChanged: (value) async {
              setState(() => _isMuted = value);
              await _settings.setMute(value);
            },
          ),
          
          const Divider(height: 32),
          
          // 游戏设置
          _buildSectionTitle('🎮 游戏设置'),
          SwitchListTile(
            title: const Text('显示伤害数字'),
            subtitle: const Text('战斗时显示伤害飘字'),
            secondary: const Icon(Icons.text_fields),
            value: _showDamageNumbers,
            onChanged: (value) async {
              setState(() => _showDamageNumbers = value);
              await _settings.toggleDamageNumbers();
            },
          ),
          SwitchListTile(
            title: const Text('粒子效果'),
            subtitle: const Text('合并/胜利时粒子特效'),
            secondary: const Icon(Icons.auto_awesome),
            value: _enableParticles,
            onChanged: (value) async {
              setState(() => _enableParticles = value);
              await _settings.toggleParticles();
            },
          ),
          
          const Divider(height: 32),
          
          // 关于
          _buildSectionTitle('ℹ️ 关于'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('游戏版本'),
            subtitle: const Text('v0.1.0 Alpha'),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('开发者'),
            subtitle: const Text('陆鸣'),
          ),
          
          const SizedBox(height: 32),
          
          // 重置按钮
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await _settings.resetToDefaults();
                await _loadSettings();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已重置为默认设置')),
                  );
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('重置为默认设置'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildVolumeSlider({
    required String label,
    required IconData icon,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(value * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.deepPurple.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: value,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
