import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../services/audio_service.dart';
import '../services/save_service.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

/// 主菜单界面
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade900,
              Colors.deepPurple.shade700,
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 游戏标题
              _buildHeader(),
              
              // 主要内容
              Expanded(
                child: _buildMenuContent(context),
              ),
              
              // 底部信息
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          // 标题文字
          const Text(
            '数字英雄传',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
              letterSpacing: 4,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  offset: Offset(3, 3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 副标题
          Text(
            '2048 RPG',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 8,
            ),
          ),
          const SizedBox(height: 20),
          // 版本标识
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: const Text(
              'v0.1.0 Alpha',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuContent(BuildContext context) {
    return FutureBuilder<bool>(
      future: Provider.of<GameProvider>(context, listen: false).hasSave(),
      builder: (context, snapshot) {
        final hasSave = snapshot.data ?? false;
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 继续游戏按钮 (有存档时显示)
            if (hasSave) ...[
              _buildMenuButton(
                context,
                icon: Icons.play_circle_outline,
                text: '继续冒险',
                color: Colors.green,
                onTap: () => _continueGame(context),
              ),
              const SizedBox(height: 16),
            ],
            
            // 开始游戏按钮
            _buildMenuButton(
              context,
              icon: Icons.play_arrow,
              text: '开始冒险',
              color: Colors.amber,
              onTap: () => _startGame(context, GameMode.classic),
            ),
            
            const SizedBox(height: 16),
            
            // 剧情模式
            _buildMenuButton(
              context,
              icon: Icons.menu_book,
              text: '剧情模式',
              color: Colors.purple,
              onTap: () => _startGame(context, GameMode.story),
            ),
            
            const SizedBox(height: 16),
            
            // 无尽塔
            _buildMenuButton(
              context,
              icon: Icons.auto_awesome,
              text: '无尽塔',
              color: Colors.red,
              onTap: () => _startGame(context, GameMode.tower),
            ),
            
            const SizedBox(height: 16),
            
            // PVP 对战
            _buildMenuButton(
              context,
              icon: Icons.swords,
              text: 'PVP 对战',
              color: Colors.orange,
              onTap: () => _showComingSoon(context),
            ),
            
            const SizedBox(height: 16),
            
            // 设置按钮
            _buildMenuButton(
              context,
              icon: Icons.settings,
              text: '设置',
              color: Colors.blueGrey,
              onTap: () => _showSettings(context),
            ),
            
            const SizedBox(height: 32),
            
            // 游戏说明
            _buildInfoCard(),
          ],
        );
      },
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.8),
              color,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Text(
            '🎮 游戏说明',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('滑动屏幕', '移动方块'),
          _buildInfoRow('相同数字', '合并升级'),
          _buildInfoRow('达到 2048', '赢得胜利'),
          const SizedBox(height: 8),
          Text(
            '在战斗模式中，撞击敌人即可发动攻击！',
            style: TextStyle(
              fontSize: 12,
              color: Colors.amber.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            left,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
          const Text(
            ' → ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white54,
            ),
          ),
          Text(
            right,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Made with ❤️ by 陆鸣',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startGame(BuildContext context, GameMode mode) async {
    final provider = Provider.of<GameProvider>(context, listen: false);
    await provider.startNewGame(mode);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GameScreen(),
      ),
    );
  }

  Future<void> _continueGame(BuildContext context) async {
    final provider = Provider.of<GameProvider>(context, listen: false);
    final hasSave = await provider.hasSave();
    
    if (hasSave) {
      final loaded = await provider.loadSave();
      if (loaded) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GameScreen(),
          ),
        );
      }
    }
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.deepPurple.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.amber, width: 2),
        ),
        title: const Text(
          '🚧 敬请期待',
          style: TextStyle(color: Colors.amber),
        ),
        content: const Text(
          'PVP 对战模式正在开发中！\n\n敬请期待后续更新...',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '好的',
              style: TextStyle(color: Colors.amber),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
}
