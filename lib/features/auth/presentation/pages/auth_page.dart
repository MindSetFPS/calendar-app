import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:calendar/features/auth/domain/auth_validation.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_event.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_state.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _emailBlurred = false;
  bool _passwordBlurred = false;
  bool _submitAttempted = false;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onEmailFocusChanged);
    _passwordFocus.addListener(_onPasswordFocusChanged);
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailFocusChanged() {
    if (!mounted || _emailFocus.hasFocus || _emailBlurred) return;
    setState(() => _emailBlurred = true);
  }

  void _onPasswordFocusChanged() {
    if (!mounted || _passwordFocus.hasFocus || _passwordBlurred) return;
    setState(() => _passwordBlurred = true);
  }

  String get _email => _emailController.text.trim();

  bool _canSubmit(AuthMode mode) {
    final password = _passwordController.text;
    final passwordError = mode == AuthMode.signIn
        ? signInPasswordError(password)
        : signUpPasswordError(password);
    return emailValidationError(_email) == null && passwordError == null;
  }

  void _submit(AuthMode mode) {
    FocusScope.of(context).unfocus();
    setState(() {
      _submitAttempted = true;
      _emailBlurred = true;
      _passwordBlurred = true;
    });

    if (!_canSubmit(mode)) return;

    context.read<AuthBloc>().add(
          AuthSubmitted(
            email: _email,
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isSignUp = state.mode == AuthMode.signUp;
        final isSubmitting = state.status == AuthStatus.submitting;

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
                        onSelectionChanged: (selection) {
                          setState(() {
                            _emailBlurred = false;
                            _passwordBlurred = false;
                            _submitAttempted = false;
                          });
                          context.read<AuthBloc>().add(
                                AuthModeChanged(selection.first),
                              );
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.mail_outline),
                          border: const OutlineInputBorder(),
                          errorText: _emailBlurred || _submitAttempted
                              ? emailValidationError(_email)
                              : null,
                          errorMaxLines: 2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: state.obscurePassword,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _submit(state.mode),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          errorText: !isSignUp &&
                                  (_passwordBlurred || _submitAttempted)
                              ? signInPasswordError(_passwordController.text)
                              : null,
                          errorMaxLines: 2,
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
                      if (isSignUp)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: _PasswordRequirements(
                            password: _passwordController.text,
                            showError: _submitAttempted,
                          ),
                        )
                      else
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
                        ),
                      if (state.errorMessage != null)
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
                        onPressed: isSubmitting
                            ? null
                            : () => _submit(state.mode),
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

class _PasswordRequirements extends StatelessWidget {
  const _PasswordRequirements({
    required this.password,
    required this.showError,
  });

  final String password;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final requirements = passwordRequirements(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final requirement in requirements)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  requirement.met
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 16,
                  color: requirement.met
                      ? theme.colorScheme.primary
                      : showError
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    requirement.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: requirement.met
                          ? theme.colorScheme.primary
                          : showError
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
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
