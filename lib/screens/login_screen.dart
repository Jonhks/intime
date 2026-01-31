import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _authService.signInAnonymously();
          },
          child: const Text('Entrar'),
        ),
      ),
    );
  }
}
