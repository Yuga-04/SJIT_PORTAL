import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedBanner extends StatelessWidget {
  const AnimatedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.white, // same dark navy as portal
      child: Lottie.asset(
        'assets/animations/banner.json', // ← your lottie file
        fit: BoxFit.contain,
        repeat: true, // loops forever like the portal
        animate: true,
        errorBuilder: (context, error, stack) {
          // Fallback if file missing
          return const _FallbackBanner();
        },
      ),
    );
  }
}

// ── Fallback shown if lottie file not yet added ───────────────────────────────
class _FallbackBanner extends StatelessWidget {
  const _FallbackBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: const Color(0xFF0B1929),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.animation, color: Colors.white24, size: 48),
            SizedBox(height: 12),
            Text(
              'Add banner.json to assets/animations/',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
