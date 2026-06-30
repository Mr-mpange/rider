import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/glass_card.dart';

class TransitCopilotScreen extends StatefulWidget {
  const TransitCopilotScreen({super.key});

  @override
  State<TransitCopilotScreen> createState() => _TransitCopilotScreenState();
}

class _TransitCopilotScreenState extends State<TransitCopilotScreen> {
  final _controller = TextEditingController();
  final _messages = <_ChatMessage>[
    const _ChatMessage(
      isUser: false,
      text: 'Hello! I am your Rider AI copilot. Ask me about routes, freight ports, or wallet analytics.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(isUser: true, text: text));
      _messages.add(const _ChatMessage(
        isUser: false,
        text: 'I found 3 optimized routes for your request. Tap Trips to book a ride now.',
      ));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Transit AI', style: AppTypography.headlineLgMobile.copyWith(color: AppColors.primary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.8),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? AppColors.primaryContainer.withValues(alpha: 0.3)
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Text(msg.text, style: AppTypography.bodyMd),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: AppTypography.bodyMd,
                      decoration: const InputDecoration(
                        hintText: 'Ask Rider AI...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(
                    onPressed: _send,
                    icon: const Icon(Icons.send, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.isUser, required this.text});
  final bool isUser;
  final String text;
}
