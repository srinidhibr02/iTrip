import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/core/widgets/gradient_button.dart';
import 'package:itrip/data/repositories/auth_repository.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;

  Future<void> _reset() async {
    if (_emailController.text.isEmpty) return;

    setState(() => _isLoading = true);
    final result = await ref
        .read(authRepositoryProvider)
        .resetPassword(_emailController.text);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _sent = result is Success;
    });

    result.when(
      success: (_) {},
      error: (f) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(f.message), backgroundColor: AppColors.error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mark_email_read,
                      size: 64, color: AppColors.success),
                  const SizedBox(height: 16),
                  Text(
                    'Reset link sent! Check your email.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Back to Login'),
                  ),
                ],
              )
            : Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GradientButton(
                    label: 'Send Reset Link',
                    isLoading: _isLoading,
                    onPressed: _reset,
                  ),
                ],
              ),
      ),
    );
  }
}
