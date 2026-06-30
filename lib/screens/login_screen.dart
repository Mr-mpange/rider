import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/phone_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController();
  String? _error;

  Future<void> _submit() async {
    final err = validateTanzaniaPhone(_phone.text);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('RIDER', style: AppTypography.textTheme.labelLarge?.copyWith(color: AppColors.primary)),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text('Support')),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 8)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome Back', style: AppTypography.headlineMdMobile.copyWith(color: AppColors.onSurface)),
                    const SizedBox(height: 8),
                    Text('Access your logistics control tower.', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                    const SizedBox(height: 24),
                    PhoneInputField(controller: _phone, errorText: _error, onChanged: (_) => setState(() => _error = null)),
                    const SizedBox(height: 20),
                    AppButton(label: 'Continue', onPressed: _submit),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('OR CONTINUE WITH', style: AppTypography.caption)),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton.icon(onPressed: _submit, icon: const Icon(Icons.g_mobiledata), label: const Text('Continue'))),
                        const SizedBox(width: 12),
                        Expanded(child: OutlinedButton.icon(onPressed: () => context.go(AppRoutes.home), icon: const Icon(Icons.apple), label: const Text('Guest'))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go(AppRoutes.home),
                        child: const Text('Continue without signing in'),
                      ),
                    ),
                    Text(
                      'Privacy Policy   Terms of Service',
                      style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
