import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/nav_drawer.dart';
import 'login_screen.dart';
import '../contents/home_content.dart'; // ← split file
import '../contents/profile_content.dart'; // ← split file
import '../contents/marks_content.dart'; // ← split file

// ── Current active screen name provider ─────────────────────────────────────
final activeScreenProvider = StateProvider<String>((ref) => 'Home');

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeScreen = ref.watch(activeScreenProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.primaryDark,
      appBar: _buildAppBar(context, ref, scaffoldKey, activeScreen),
      drawer: const NavDrawer(),
      body: _buildBody(activeScreen),
    );
  }

  // ── App bar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<ScaffoldState> scaffoldKey,
    String activeScreen,
  ) {
    final auth = ref.watch(authProvider);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.black12,
      leadingWidth: 30,
      toolbarHeight: 50,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppTheme.primaryDark, size: 26),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
      title: Row(
        children: [
          Image.asset(
            'assets/images/sjit_tech.png',
            width: 125,
            height: 150,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.school, color: AppTheme.accentBlue, size: 42),
          ),
        ],
      ),
      actions: [
        Center(
          child: Text(
            activeScreen,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDark,
            ),
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () => _showUserSheet(context, ref, auth),
          child: Container(
            margin: const EdgeInsets.only(right: 14),
            width: 40,
            height: 40,
            child: ClipOval(
              child: Image.asset(
                'assets/images/profile.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Body — swap content based on active screen ─────────────────────────────
  Widget _buildBody(String screen) {
    switch (screen) {
      case 'Home':
        return const HomeContent(); // ← home_content.dart
      case 'Profile':
        return const ProfileContent(); // ← profile_content.dart
      case 'Marks':
        return const MarksContent(); // ← marks_content.dart
      default:
        return _ComingSoonContent(screen);
    }
  }

  // ── User bottom sheet ──────────────────────────────────────────────────────
  void _showUserSheet(BuildContext context, WidgetRef ref, AuthState auth) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F2237),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 28,
              backgroundColor: AppTheme.accentBlue,
              child: Icon(Icons.person, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              auth.username ?? 'Student',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'SJIT Student',
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
                icon: const Icon(Icons.logout, size: 18),
                label: Text(
                  'Logout',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  COMING SOON PLACEHOLDER
// ════════════════════════════════════════════════════════════════════════════
class _ComingSoonContent extends StatelessWidget {
  final String screen;
  const _ComingSoonContent(this.screen);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_iconFor(screen), size: 72, color: Colors.white24),
                  const SizedBox(height: 16),
                  Text(
                    screen,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Coming soon',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white30,
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.0, 1.0),
              ),
    );
  }

  IconData _iconFor(String screen) {
    switch (screen) {
      case 'Attendance':
        return Icons.calendar_today_outlined;
      case 'Marks':
        return Icons.bar_chart_outlined;
      case 'Notes':
        return Icons.notes_outlined;
      case 'Downloads':
        return Icons.download_outlined;
      case 'Feedback':
        return Icons.feedback_outlined;
      case 'Achievements':
        return Icons.emoji_events_outlined;
      case 'Placements':
        return Icons.work_outline;
      case 'Black Box':
        return Icons.layers_outlined;
      case 'Apply':
        return Icons.send_outlined;
      case 'Fee':
        return Icons.payment_outlined;
      default:
        return Icons.web_outlined;
    }
  }
}
