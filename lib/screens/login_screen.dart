import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/network_background.dart';
import 'home_screen.dart';

// const double kLogoSize = 100.0;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();
  bool _obscurePassword = true;
  String _captchaText = '';

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  void _generateCaptcha() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random();
    setState(() {
      _captchaText = String.fromCharCodes(
        Iterable.generate(
          5,
          (_) => chars.codeUnitAt(rng.nextInt(chars.length)),
        ),
      );
    });
  }

  Future<void> _handleLogin() async {
    if (_captchaController.text.toUpperCase() != _captchaText) {
      _showSnack('Incorrect captcha. Please try again.', isError: true);
      _generateCaptcha();
      _captchaController.clear();
      return;
    }
    final ok = await ref
        .read(authProvider.notifier)
        .login(
          _usernameController.text.trim(),
          _passwordController.text,
          _captchaController.text,
        );
    if (ok && mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else if (mounted) {
      _showSnack(
        ref.read(authProvider).error ?? 'Login failed.',
        isError: true,
      );
      _generateCaptcha();
      _captchaController.clear();
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: isError ? Colors.redAccent : AppTheme.accentBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).status == AuthStatus.loading;

    return Scaffold(
      body: NetworkBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: _buildLoginCard(
                isLoading,
              ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1, end: 0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(bool isLoading) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 48,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Logo ─────────────────────────────────────────────────
          Center(
            child:
                Image.asset(
                      'assets/images/sjit_tech.png',
                      width: 200,
                      height: 100,
                      fit: BoxFit.contain,
                    )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .scale(
                      begin: const Offset(0.7, 0.7),
                      end: const Offset(1.0, 1.0),
                    ),
          ),
          const SizedBox(height: 32),

          // ── Username ──────────────────────────────────────────────
          _textField(controller: _usernameController, hint: 'Username'),
          const SizedBox(height: 14),

          // ── Password ──────────────────────────────────────────────
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: _inputTextStyle,
            decoration: _inputDeco('Password').copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppTheme.textGrey,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Captcha display ───────────────────────────────────────
          _buildCaptchaBox(),
          const SizedBox(height: 14),

          // ── Captcha input ─────────────────────────────────────────
          _textField(
            controller: _captchaController,
            hint: 'Captcha',
            caps: TextCapitalization.characters,
          ),
          const SizedBox(height: 24),

          // ── LOG IN button ─────────────────────────────────────────
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'LOG IN',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 2,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Forgot password ───────────────────────────────────────
          Center(
            child: GestureDetector(
              onTap: () => _showSnack('Contact admin to reset your password.'),
              child: Text(
                'Forgot your password?',
                style: GoogleFonts.poppins(
                  color: AppTheme.accentBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.accentBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptchaBox() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _captchaText,
              style: GoogleFonts.sourceCodePro(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1B3A6B),
                letterSpacing: 8,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.red.withOpacity(0.6),
                decorationThickness: 2.5,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.textGrey, size: 20),
            onPressed: () {
              _generateCaptcha();
              _captchaController.clear();
            },
          ),
        ],
      ),
    );
  }

  TextStyle get _inputTextStyle =>
      GoogleFonts.poppins(color: AppTheme.primaryDark, fontSize: 14);

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextCapitalization caps = TextCapitalization.none,
  }) {
    return TextField(
      controller: controller,
      textCapitalization: caps,
      style: _inputTextStyle,
      decoration: _inputDeco(hint),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: AppTheme.textGrey, fontSize: 13),
      filled: true,
      fillColor: AppTheme.inputBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppTheme.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppTheme.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppTheme.accentBlue, width: 1.8),
      ),
    );
  }
}
