import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:calendar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_event.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_state.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _email => _emailController.text.trim();

  bool _canSubmit(AuthMode mode) {
    final hasEmail = _email.contains('@') && _email.length >= 3;
    final hasPassword = _passwordController.text.length >= 6;
    final hasName = mode == AuthMode.signIn || _nameController.text.trim().isNotEmpty;
    return hasEmail && hasPassword && hasName;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
          AuthSubmitted(
            name: _nameController.text,
            email: _email,
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, next) =>
          next.status == AuthStatus.success &&
          previous.status != AuthStatus.success,
      listener: (context, state) {
        final verb =
            state.mode == AuthMode.signUp ? 'Account created' : 'Signed in';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$verb as ${state.user?.name ?? _email} (mockup)'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      builder: (context, state) {
        final isSignUp = state.mode == AuthMode.signUp;
        final isSubmitting = state.status == AuthStatus.submitting;
        final canSubmit = _canSubmit(state.mode) && !isSubmitting;

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _BrandMark(),
                      const SizedBox(height: 20),
                      Text(
                        isSignUp ? 'Create your account' : 'Welcome back',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isSignUp
                            ? 'Join Pulse and share what you are up to.'
                            : 'Sign in to catch up on your feed.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 24),
                      SegmentedButton<AuthMode>(
                        segments: const [
                          ButtonSegment(
                            value: AuthMode.signIn,
                            label: Text('Sign in'),
                          ),
                          ButtonSegment(
                            value: AuthMode.signUp,
                            label: Text('Sign up'),
                          ),
                        ],
                        selected: {state.mode},
                        onSelectionChanged: (selection) =>
                            context.read<AuthBloc>().add(
                                  AuthModeChanged(selection.first),
                                ),
                      ),
                      const SizedBox(height: 20),
                      if (isSignUp) ...[
                        TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Full name',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: state.obscurePassword,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) {
                          if (canSubmit) _submit();
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          helperText: isSignUp ? 'At least 6 characters' : null,
                          suffixIcon: IconButton(
                            onPressed: () => context.read<AuthBloc>().add(
                                  const AuthPasswordVisibilityToggled(),
                                ),
                            icon: Icon(
                              state.obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                      if (!isSignUp)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text('Password reset (mockup)'),
                                duration: Duration(seconds: 1),
                              ),
                            ),
                            child: const Text('Forgot password?'),
                          ),
                        )
                      else
                        const SizedBox(height: 16),
                      if (state.status == AuthStatus.failure &&
                          state.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            state.errorMessage!,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: scheme.error),
                          ),
                        ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: canSubmit ? _submit : null,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(isSignUp ? 'Create account' : 'Sign in'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF6C4DF6), Color(0xFFEF5DA8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(
            Icons.monitor_heart_outlined,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Pulse',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
        ),
      ],
    );
  }
}
