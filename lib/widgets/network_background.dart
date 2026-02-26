import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ═══════════════════════════════════════════════════════════════════════════
// CONFIG — tweak these values to control the animation
// ═══════════════════════════════════════════════════════════════════════════

class NetworkConfig {
  /// Number of floating dots
  final int dotCount;

  /// Dot size in pixels
  final double dotRadius;

  /// Dot brightness (0.0–1.0)
  final double dotOpacity;

  /// Soft glow behind each dot
  final bool dotGlow;

  /// Max pixel distance between dots to draw a line
  final double connectionDistance;

  /// Line brightness (0.0–1.0)
  final double lineOpacity;

  /// Line thickness
  final double lineWidth;

  /// Base speed of dots in pixels per second
  final double speed;

  /// Background gradient colors
  final List<Color> backgroundColors;

  const NetworkConfig({
    this.dotCount = 50,
    this.dotRadius = 3.1,
    this.dotOpacity = 0.80,
    this.dotGlow = true,
    this.connectionDistance = 200,
    this.lineOpacity = 0.50,
    this.lineWidth = 0.9,
    this.speed = 40.0, // pixels per second — keep 30–60 for slow float
    this.backgroundColors = const [
      Color(0xFF08111E),
      Color(0xFF0D1E36),
      Color(0xFF0A1929),
    ],
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// WIDGET
// ═══════════════════════════════════════════════════════════════════════════

class NetworkBackground extends StatefulWidget {
  final NetworkConfig config;
  final Widget? child;

  const NetworkBackground({
    super.key,
    this.config = const NetworkConfig(),
    this.child,
  });

  @override
  State<NetworkBackground> createState() => _NetworkBackgroundState();
}

class _NetworkBackgroundState extends State<NetworkBackground>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _last = Duration.zero;

  // Each dot: position + velocity
  final List<_Dot> _dots = [];
  Size _size = Size.zero;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _initDots(Size size) {
    _dots.clear();
    final rng = Random();
    final cfg = widget.config;
    for (int i = 0; i < cfg.dotCount; i++) {
      // random position
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      // random direction angle
      final angle = rng.nextDouble() * 2 * pi;
      // speed with slight variation per dot
      final spd = cfg.speed * (0.5 + rng.nextDouble() * 1.0);
      _dots.add(_Dot(x: x, y: y, vx: cos(angle) * spd, vy: sin(angle) * spd));
    }
    _size = size;
    _initialized = true;
  }

  void _onTick(Duration elapsed) {
    if (_size == Size.zero) return;
    final dt = _last == Duration.zero
        ? 0.0
        : (elapsed - _last).inMicroseconds / 1000000.0; // seconds
    _last = elapsed;

    for (final dot in _dots) {
      dot.x += dot.vx * dt;
      dot.y += dot.vy * dt;

      // Bounce off edges
      if (dot.x <= 0) {
        dot.x = 0;
        dot.vx = dot.vx.abs();
      } else if (dot.x >= _size.width) {
        dot.x = _size.width;
        dot.vx = -dot.vx.abs();
      }

      if (dot.y <= 0) {
        dot.y = 0;
        dot.vy = dot.vy.abs();
      } else if (dot.y >= _size.height) {
        dot.y = _size.height;
        dot.vy = -dot.vy.abs();
      }
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        // Init dots once we know the screen size
        if (!_initialized || _size != size) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _initDots(size);
          });
        }

        return CustomPaint(
          size: size,
          painter: _NetworkPainter(
            dots: List.unmodifiable(_dots),
            config: widget.config,
            size: size,
          ),
          child: SizedBox.expand(child: widget.child),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PAINTER
// ═══════════════════════════════════════════════════════════════════════════

class _NetworkPainter extends CustomPainter {
  final List<_Dot> dots;
  final NetworkConfig config;
  final Size size;

  const _NetworkPainter({
    required this.dots,
    required this.config,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ── background ────────────────────────────────────────────────────
    final colors = config.backgroundColors;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors.length >= 2 ? colors : [colors.first, colors.first],
          stops: colors.length == 3 ? const [0.0, 0.5, 1.0] : null,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    if (dots.isEmpty) return;

    // ── connecting lines ──────────────────────────────────────────────
    final linePaint = Paint()..strokeWidth = config.lineWidth;
    final maxDist = config.connectionDistance;

    for (int i = 0; i < dots.length; i++) {
      for (int j = i + 1; j < dots.length; j++) {
        final dx = dots[i].x - dots[j].x;
        final dy = dots[i].y - dots[j].y;
        final dist = sqrt(dx * dx + dy * dy);

        if (dist < maxDist) {
          final opacity = (1.0 - dist / maxDist) * config.lineOpacity;
          linePaint.color = Colors.white.withOpacity(opacity);
          canvas.drawLine(
            Offset(dots[i].x, dots[i].y),
            Offset(dots[j].x, dots[j].y),
            linePaint,
          );
        }
      }
    }

    // ── dots ──────────────────────────────────────────────────────────
    for (final d in dots) {
      final p = Offset(d.x, d.y);

      if (config.dotGlow) {
        canvas.drawCircle(
          p,
          config.dotRadius * 3,
          Paint()
            ..color = Colors.white.withOpacity(0.08)
            ..maskFilter = MaskFilter.blur(
              BlurStyle.normal,
              config.dotRadius * 2.5,
            ),
        );
      }

      canvas.drawCircle(
        p,
        config.dotRadius,
        Paint()..color = Colors.white.withOpacity(config.dotOpacity),
      );
    }
  }

  @override
  bool shouldRepaint(_NetworkPainter old) => true; // always repaint on tick
}

// ═══════════════════════════════════════════════════════════════════════════
// DOT MODEL — mutable, updated every tick
// ═══════════════════════════════════════════════════════════════════════════

class _Dot {
  double x, y; // current position (pixels)
  double vx, vy; // velocity (pixels/second)

  _Dot({required this.x, required this.y, required this.vx, required this.vy});
}
