import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 粒子效果服务
class ParticleService {
  static final ParticleService _instance = ParticleService._internal();
  factory ParticleService() => _instance;
  ParticleService._internal();

  bool _enabled = true;

  bool get enabled => _enabled;
  set enabled(bool value) => _enabled = value;

  /// 创建爆炸粒子效果
  List<Particle> createExplosion(
    Offset center, {
    int count = 20,
    Color? color,
    double speed = 1.0,
  }) {
    if (!_enabled) return [];

    final random = math.Random();
    final particles = <Particle>[];

    for (int i = 0; i < count; i++) {
      final angle = (2 * math.pi * i) / count + random.nextDouble() * 0.5;
      final velocity = math.Random().nextDouble() * 3 * speed + 2;
      
      particles.add(Particle(
        position: center,
        velocity: Offset(
          math.cos(angle) * velocity,
          math.sin(angle) * velocity,
        ),
        color: color ?? Colors.amber,
        size: random.nextDouble() * 6 + 4,
        life: 1.0,
        decay: 0.02 + random.nextDouble() * 0.02,
      ));
    }

    return particles;
  }

  /// 创建合并粒子效果
  List<Particle> createMerge(
    Offset center, {
    int count = 12,
    Color? color,
  }) {
    if (!_enabled) return [];

    final random = math.Random();
    final particles = <Particle>[];

    for (int i = 0; i < count; i++) {
      final angle = (2 * math.pi * i) / count;
      final velocity = 2.0;
      
      particles.add(Particle(
        position: center,
        velocity: Offset(
          math.cos(angle) * velocity,
          math.sin(angle) * velocity,
        ),
        color: color ?? Colors.blue,
        size: random.nextDouble() * 4 + 3,
        life: 1.0,
        decay: 0.03,
      ));
    }

    return particles;
  }

  /// 创建胜利粒子效果
  List<Particle> createVictory(
    Offset center, {
    int count = 50,
  }) {
    if (!_enabled) return [];

    final random = math.Random();
    final particles = <Particle>[];
    final colors = [Colors.amber, Colors.yellow, Colors.orange, Colors.red];

    for (int i = 0; i < count; i++) {
      final angle = random.nextDouble() * 2 * math.pi;
      final velocity = random.nextDouble() * 5 + 3;
      
      particles.add(Particle(
        position: center,
        velocity: Offset(
          math.cos(angle) * velocity,
          math.sin(angle) * velocity - 2, // 向上飘
        ),
        color: colors[random.nextInt(colors.length)],
        size: random.nextDouble() * 8 + 4,
        life: 1.0,
        decay: 0.015,
      ));
    }

    return particles;
  }

  /// 更新粒子状态
  List<Particle> updateParticles(List<Particle> particles) {
    return particles
        .map((p) => p.update())
        .where((p) => p.life > 0)
        .toList();
  }
}

/// 单个粒子
class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double life;
  double decay;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.life,
    required this.decay,
  });

  /// 更新粒子状态
  Particle update() {
    position += velocity;
    velocity += Offset(0, 0.1); // 重力
    life -= decay;
    size *= 0.98;
    return this;
  }

  /// 绘制粒子
  void paint(Canvas canvas, Paint paint) {
    if (life <= 0) return;

    paint.color = color.withOpacity(life);
    canvas.drawCircle(position, size, paint);
  }
}

/// 粒子效果容器 Widget
class ParticleOverlay extends StatefulWidget {
  final List<Particle> particles;
  final bool isVisible;

  const ParticleOverlay({
    super.key,
    required this.particles,
    this.isVisible = true,
  });

  @override
  State<ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<ParticleOverlay>
    with TickerProviderStateMixin {
  final Paint _paint = Paint();

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible || widget.particles.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      painter: _ParticlePainter(
        particles: widget.particles,
        paint: _paint,
      ),
      size: Size.infinite,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Paint paint;

  _ParticlePainter({
    required this.particles,
    required this.paint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      particle.paint(canvas, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
