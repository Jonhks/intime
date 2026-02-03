import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final navigator = Navigator.of(context);

            await _authService.signInAnonymously();

            if (!mounted) return;

            navigator.pop(); // cierra LoginScreen
            navigator.pop(); // cierra ProtectWordsScreen
          },
          child: const Text('Entrar'),
        ),
      ),
    );
  }
}
