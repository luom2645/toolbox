import 'package:flutter/material.dart';

/// 粒子效果服务
class ParticleService extends ChangeNotifier {
  static final ParticleService _instance = ParticleService._internal();
  factory ParticleService() => _instance;
  ParticleService._internal();

  bool _enabled = true;
  final List<Particle> _particles = [];

  bool get enabled => _enabled;
  List<Particle> get particles => List.unmodifiable(_particles);

  /// 启用/禁用粒子
  void toggleEnabled() {
    _enabled = !_enabled;
    if (!_enabled) {
      _particles.clear();
    }
    notifyListeners();
  }

  /// 添加粒子
  void addParticle(Particle particle) {
    if (!_enabled) return;
    _particles.add(particle);
    notifyListeners();
  }

  /// 添加爆炸粒子效果
  void addExplosion(Offset center, Color color, {int count = 20}) {
    if (!_enabled) return;
    
    final random = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < count; i++) {
      final angle = (random + i * 18) % 360;
      final speed = 50 + (random % 100);
      _particles.add(Particle(
        position: center,
        velocity: Offset(
          speed * (angle * 3.14159 / 180).toDouble(),
          speed * ((angle + 90) * 3.14159 / 180).toDouble(),
        ),
        color: color,
        size: 2 + (random % 4),
        lifetime: 500 + (random % 300),
      ));
    }
    notifyListeners();
  }

  /// 更新粒子
  void updateParticles(int deltaTime) {
    if (!_enabled) return;
    
    _particles.removeWhere((particle) {
      particle.update(deltaTime);
      return particle.isDead;
    });
    notifyListeners();
  }

  /// 清除所有粒子
  void clear() {
    _particles.clear();
    notifyListeners();
  }
}

/// 单个粒子
class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  int lifetime;
  int age = 0;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.lifetime,
  });

  bool get isDead => age >= lifetime;

  void update(int deltaTime) {
    age += deltaTime;
    position += velocity * (deltaTime / 1000);
    velocity = velocity * 0.95; // 阻力
    size *= 0.98; // 逐渐缩小
  }
}
