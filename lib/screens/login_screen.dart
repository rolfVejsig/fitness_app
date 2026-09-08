import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  final ApiService apiService = ApiService();

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      showMessage('Please enter username and password');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await apiService.login(
        username,
        password,
      );

      if (result['success'] == true) {
        showMessage('Login successful');

        // Senere:
        // Navigator.pushReplacement(...)
      } else {
        showMessage(result['message'] ?? 'Login failed');
      }
    } catch (e) {
      showMessage('Could not connect to server');
    }

    setState(() {
      isLoading = false;
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF022045);
    const blue = Color(0xFF03346E);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // Top blue circle
              Container(
                height: 280,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(180),
                    bottomRight: Radius.circular(180),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Login',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 58,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 45),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38),
                child: Column(
                  children: [

                    // Username
                    TextField(
                      controller: usernameController,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: GoogleFonts.lato(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Enter your username',
                        hintStyle: GoogleFonts.lato(
                          color: Colors.grey,
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Password
                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.lato(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'Enter your password',
                        hintStyle: GoogleFonts.lato(
                          color: Colors.grey,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Login',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Social login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        socialButton(
                          const Icon(
                            Icons.g_mobiledata,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 25),
                        socialButton(
                          const Icon(
                            Icons.facebook,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 25),
                        socialButton(
                          const Icon(
                            Icons.apple,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.lato(
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
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

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget socialButton(Widget icon) {
    return Container(
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(child: icon),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}