import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sjit_portal/contents/feedback_content.dart';
import 'package:sjit_portal/contents/notes_content.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/nav_drawer.dart';
import 'login_screen.dart';
import '../contents/home_content.dart'; // ← split file
import '../contents/profile_content.dart'; // ← split file
import '../contents/marks_content.dart'; // ← split file
import '../contents/attendance_content.dart'; // ← split file
import '../contents/fee_content.dart'; // ← split file

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
        return const HomeContent();
      case 'Profile':
        return const ProfileContent();
      case 'Marks':
        return const MarksContent();
      case 'Attendance':
        return const AttendanceContent();
      case 'Notes':
        return const NotesContent();
      case 'Feedback':
        return const FeedbackContent();
      case 'Fee':
        return const FeeContent(); // ← use FeeContent, not FeeScreen
      default:
        return _ComingSoonContent(screen);
    }
  }

  // ── User bottom sheet ──────────────────────────────────────────────────────
  void _showUserSheet(BuildContext context, WidgetRef ref, AuthState auth) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, _, __) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return ScaleTransition(
          scale: curved,
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              backgroundColor: AppTheme.cardWhite,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 100,
              ), // reduces card width
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close button row
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.borderColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Profile image
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppTheme.borderColor,
                      backgroundImage: const AssetImage(
                        'assets/images/profile.png',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Info rows
                    _infoRow('NAME', auth.name ?? '-'),
                    _infoRow('ROLL NO', auth.rollNo ?? '-'),
                    _infoRow('COURSE', auth.course ?? '-'),
                    _infoRow('DEPT', auth.dept ?? '-'),
                    _infoRow('SECTION', auth.section ?? '-'),

                    const SizedBox(height: 24),

                    // Logout button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await ref.read(authProvider.notifier).logout();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryDark,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Logout',
                          style: GoogleFonts.poppins(
                            color: AppTheme.cardWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: GoogleFonts.poppins(
              color: AppTheme.primaryDark,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
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
