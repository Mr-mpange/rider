import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/phone_input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _nameError;
  String? _phoneError;

  Future<void> _register() async {
    final nameError = _nameController.text.trim().isEmpty
        ? 'Jina linahitajika'
        : null;
    final phoneError = validateTanzaniaPhone(_phoneController.text);
    if (nameError != null || phoneError != null) {
      setState(() {
        _nameError = nameError;
        _phoneError = phoneError;
      });
      return;
    }
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'RIDER',
          style: AppTypography.textTheme.displayLarge?.copyWith(
            fontSize: 24,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jisajili RIDER', style: AppTypography.headlineMdMobile),
              const SizedBox(height: 8),
              Text(
                'Unda akaunti yako kuanza kusafiri kwa urahisi.',
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              Text('Jina Kamili', style: AppTypography.textTheme.labelLarge),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Mf. Juma Hamisi',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    prefixIcon: Icon(Icons.person_outline, color: AppColors.outline),
                  ),
                ),
              ),
              if (_nameError != null) ...[
                const SizedBox(height: 4),
                Text(_nameError!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
              ],
              const SizedBox(height: 24),
              PhoneInputField(
                controller: _phoneController,
                errorText: _phoneError,
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Endelea',
                onPressed: _register,
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: Text(
                    'Endelea kama mgeni',
                    style: AppTypography.textTheme.labelLarge?.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
