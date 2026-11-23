import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_text_field.dart';
import 'home_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.viewModel});

  final AuthViewModel? viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AuthViewModel _viewModel;
  late final bool _ownsViewModel;

  @override
  void initState() {
    super.initState();
    _ownsViewModel = widget.viewModel == null;
    _viewModel = widget.viewModel ?? AuthViewModel();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = await _viewModel.login(
        usernameOrEmail: _usernameController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => HomeScreen(username: user.username),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      _showMessage(_viewModel.errorMessage ?? error.message);
      _viewModel.clearError();
    }
  }

  Future<void> _openSignUp() async {
    final createdUsername = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => SignUpScreen(viewModel: _viewModel),
      ),
    );
    if (!mounted || createdUsername == null) return;

    _usernameController.text = createdUsername;
    _showMessage('Account created. You can now log in.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 230,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(160),
                        bottomRight: Radius.circular(160),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Login',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthTextField(
                            controller: _usernameController,
                            label: 'Username or email',
                            hint: 'Enter your username or email',
                            icon: Icons.person_outline,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Enter your username or email.'
                                : null,
                          ),
                          const SizedBox(height: 18),
                          AuthTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Enter your password',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _login(),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Enter your password.'
                                : null,
                          ),
                          const SizedBox(height: 28),
                          AuthSubmitButton(
                            label: 'Login',
                            isLoading: _viewModel.isLoading,
                            onPressed: _login,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: GoogleFonts.lato(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: _viewModel.isLoading
                                    ? null
                                    : _openSignUp,
                                child: Text(
                                  'Sign up',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    if (_ownsViewModel) _viewModel.dispose();
    super.dispose();
  }
}
