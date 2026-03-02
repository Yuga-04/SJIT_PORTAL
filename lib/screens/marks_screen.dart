import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../contents/marks_content.dart';

/// Standalone Marks screen — can be pushed via Navigator
/// OR just use MarksContent directly inside HomeScreen's _buildBody switch.
class MarksScreen extends StatelessWidget {
  const MarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        toolbarHeight: 50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppTheme.primaryDark, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Marks',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDark,
          ),
        ),
        centerTitle: false,
      ),
      body: const MarksContent(),
    );
  }
}