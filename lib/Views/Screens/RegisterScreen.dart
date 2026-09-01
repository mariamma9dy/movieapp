import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movieapp/Controllers/FirebaseAuthController.dart';
import 'package:movieapp/Providers/FirebaseAuthProvider.dart';
import 'package:movieapp/Views/Screens/LogInScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // MARK:- Controllers & Variables

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  late FirebaseAuthController authController;

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // MARK:- Provider & Controller

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = Provider.of<FirebaseAuthProvider>(context, listen: false);

    authController = FirebaseAuthController(provider: provider);
  }

  // MARK:- Register

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty) {
      authController.provider.setError('Please enter your email');
      return;
    }

    if (password.isEmpty) {
      authController.provider.setError('Please enter your password');
      return;
    }

    if (confirmPassword.isEmpty) {
      authController.provider.setError('Please confirm your password');
      return;
    }

    if (password != confirmPassword) {
      authController.provider.setError('Passwords do not match');
      return;
    }

    final success = await authController.register(
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LogInScreen()),
      );
    }
  }

  // MARK:- Dispose

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // MARK:- UI

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FirebaseAuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MARK:- Header
              const SizedBox(height: 30),

              Center(
                child: Column(
                  children: [
                    Icon(Icons.movie_outlined, size: 64),

                    const SizedBox(height: 16),

                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Create your account and start exploring movies',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 45),

              // MARK:- Email
              Text(
                'Email',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // MARK:- Password
              Text(
                'Password',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // MARK:- Confirm Password
              Text(
                'Confirm Password',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: confirmPasswordController,
                obscureText: !isConfirmPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Confirm your password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // MARK:- Error Message
              if (provider.errorMessage != null)
                Text(
                  provider.errorMessage!,
                  style: const TextStyle(fontSize: 14),
                ),

              const SizedBox(height: 25),

              // MARK:- Register Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : register,
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Account'),
                ),
              ),

              const SizedBox(height: 20),

              // MARK:- Login Navigation
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LogInScreen(),
                          ),
                        );
                      },
                      child: const Text('Login'),
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
