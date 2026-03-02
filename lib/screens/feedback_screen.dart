import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/nav_drawer.dart';
import '../contents/feedback_content.dart';

class FeedbackScreen extends ConsumerWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      appBar: _buildAppBar(context, scaffoldKey),
      drawer: const NavDrawer(),
      body: const FeedbackContent(),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) {
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
            'Feedback',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDark,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Container(
          margin: const EdgeInsets.only(right: 14),
          width: 40,
          height: 40,
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => CircleAvatar(
                backgroundColor: AppTheme.accentBlue,
                child: const Icon(Icons.person, color: Colors.white, size: 22),
              ),
            ),
          ),
        ),
      ],
    );
  }
}