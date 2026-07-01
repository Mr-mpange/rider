import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/router/app_router.dart';
import '../core/services/auth_service.dart';
import '../core/constants/app_branding.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/app_dialogs.dart';
import '../widgets/app_button.dart';
import '../widgets/glass_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool _busy = false;
  bool _obscure = true;

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty) {
      setState(() => _error = 'Enter your email');
      return;
    }
    if (password.isEmpty) {
      setState(() => _error = 'Enter your password');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await context.read<AuthService>().signInWithEmail(email: email, password: password);
      if (mounted) context.go(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => _error = _friendlyAuthMessage(e));
    } catch (_) {
      if (mounted) setState(() => _error = 'Email or password is incorrect');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: const Locale('en'),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                children: [
                  Text(AppBranding.appName, style: AppTypography.labelMd.copyWith(color: AppColors.primary, letterSpacing: 2)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text('Logistics.', style: AppTypography.caption.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryFixedDim.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: AppColors.secondaryContainer, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text('Live Network Pulse', style: AppTypography.caption.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GlassCard(
                padding: const EdgeInsets.all(24),
                premium: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome Back', style: AppTypography.headlineMdMobile),
                    const SizedBox(height: 8),
                    Text(
                      'Access your logistics control tower.',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),
                    _Field(
                      controller: _emailController,
                      label: 'EMAIL',
                      hint: 'name@example.com',
                      icon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _Field(
                      controller: _passwordController,
                      label: 'PASSWORD',
                      hint: 'Enter your password',
                      icon: Icons.lock_outline,
                      obscureText: _obscure,
                      suffix: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      labelTrailing: TextButton(
                        onPressed: () => AppDialogs.showInfoSheet(
                          context,
                          title: 'Reset Password',
                          body: 'A password reset link will be sent to your registered email.',
                          cta: 'Send Reset Link',
                        ),
                        child: const Text('Forgot?'),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(_error!, style: const TextStyle(color: AppColors.error)),
                    ],
                    const SizedBox(height: 20),
                    AppButton(
                      label: _busy ? 'Loading...' : 'Login',
                      onPressed: _busy ? null : _submit,
                      enabled: !_busy,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.outlineVariant.withValues(alpha: 0.6))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('OR CONTINUE WITH', style: AppTypography.caption.copyWith(letterSpacing: 1)),
                        ),
                        Expanded(child: Divider(color: AppColors.outlineVariant.withValues(alpha: 0.6))),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _busy
                                ? null
                                : () async {
                                    setState(() {
                                      _busy = true;
                                      _error = null;
                                    });
                                    try {
                                      await context.read<AuthService>().signInWithGoogle();
                                      if (!context.mounted) return;
                                      context.go(AppRoutes.home);
                                    } catch (_) {
                                      if (mounted) {
                                        setState(() => _error = 'Google sign in is not available right now');
                                      }
                                    } finally {
                                      if (mounted) setState(() => _busy = false);
                                    }
                                  },
                            icon: const Icon(Icons.g_mobiledata, size: 22),
                            label: const Text('Google'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => AppDialogs.showInfoSheet(
                              context,
                              title: 'Apple Sign In',
                              body: 'Continue with your Apple ID.',
                              cta: 'Continue',
                            ),
                            icon: const Icon(Icons.apple, size: 20),
                            label: const Text('Apple'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go(AppRoutes.register),
                        child: const Text('Create an account'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  children: [
                    TextButton(
                      onPressed: () => AppDialogs.showInfoSheet(
                        context,
                        title: 'Privacy Policy',
                        body: 'Review how RIIDER protects your logistics and personal data.',
                        cta: 'Close',
                      ),
                      child: const Text('Privacy Policy'),
                    ),
                    TextButton(
                      onPressed: () => AppDialogs.showInfoSheet(
                        context,
                        title: 'Terms of Service',
                        body: 'Review the RIIDER platform terms and enterprise usage policy.',
                        cta: 'Close',
                      ),
                      child: const Text('Terms of Service'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.outline),
                    const SizedBox(width: 6),
                    Text(
                      'Secure Enterprise Login • 256-bit Encryption',
                      style: AppTypography.caption.copyWith(color: AppColors.outline),
                    ),
                  ],
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

String _friendlyAuthMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'Enter a valid email address';
    case 'user-not-found':
      return 'No account found for this email';
    case 'wrong-password':
    case 'invalid-credential':
      return 'Email or password is incorrect';
    case 'user-disabled':
      return 'This account is disabled';
    case 'operation-not-allowed':
      return 'Email/password sign-in is not enabled in Firebase';
    case 'network-request-failed':
      return 'Network unavailable. Try again';
    default:
      return e.message ?? 'Unable to sign in';
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.labelTrailing,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final Widget? labelTrailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTypography.caption.copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w700)),
            if (labelTrailing != null) ...[const Spacer(), labelTrailing!],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              prefixIcon: Icon(icon, color: AppColors.outline),
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }
}
