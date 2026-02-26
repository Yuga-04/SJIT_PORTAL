import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';

class NavDrawer extends ConsumerWidget {
  const NavDrawer({super.key});

  static const _items = [
    (Icons.home_outlined, 'Home'),
    (Icons.person_outline, 'Profile'),
    (Icons.calendar_today_outlined, 'Attendance'),
    (Icons.bar_chart_outlined, 'Marks'),
    (Icons.notes_outlined, 'Notes'),
    (Icons.download_outlined, 'Downloads'),
    (Icons.feedback_outlined, 'Feedback'),
    (Icons.emoji_events_outlined, 'Achievements'),
    (Icons.work_outline, 'Placements'),
    (Icons.layers_outlined, 'Black Box'),
    (Icons.send_outlined, 'Apply'),
    (Icons.payment_outlined, 'Fee'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeScreen = ref.watch(activeScreenProvider);

    return Drawer(
      backgroundColor: Colors.white, // ✅ WHITE DRAWER
      child: Column(
        children: [
          // ── Header ────────────────────────────

          // ── Nav Items ─────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(10, 52, 0, 24),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/sjit_tech.png',
                        width: 200,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                ..._items.map((item) {
                  final isActive = activeScreen == item.$2;
                  return _NavTile(
                    icon: item.$1,
                    label: item.$2,
                    isActive: isActive,
                    onTap: () {
                      ref.read(activeScreenProvider.notifier).state = item.$2;
                      Navigator.pop(context);
                    },
                  );
                }),

                const Divider(height: 30),

                // Logout
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: Text(
                    'Logout',
                    style: GoogleFonts.poppins(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: isActive ? AppTheme.accentBlue.withOpacity(0.1) : null,
      leading: Icon(
        icon,
        color: isActive ? AppTheme.accentBlue : AppTheme.textGrey,
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          color: isActive ? AppTheme.accentBlue : Colors.black87,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      onTap: onTap,
    );
  }
}
