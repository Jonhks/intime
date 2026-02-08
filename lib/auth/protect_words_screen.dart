import 'package:flutter/material.dart';
import '../widgets/responsive_layout.dart';
import '../screens/login_screen.dart';
import '../auth/auth_service.dart';

class ProtectWordsScreen extends StatelessWidget {
  const ProtectWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    final rightContent = Scaffold(
      appBar: AppBar(
        title: const Text('Protege tus palabras'),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal
            Text(
              'Protege tus palabras',
              style: Theme.of(context).textTheme.headlineLarge,
            ),

            const SizedBox(height: 16),

            // Texto explicativo
            Text(
              'Para que este mensaje no se pierda y solo tú puedas editarlo, '
              'necesitamos asociarlo a una cuenta segura.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 32),

            // ✅ GOOGLE SIGN-IN (REAL)
            ElevatedButton(
              onPressed: () async {
                try {
                  await authService.linkWithGoogle();
                  Navigator.pop(context);
                } catch (e) {
                  debugPrint('🔥 ERROR GOOGLE AUTH: $e');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      duration: const Duration(seconds: 6),
                    ),
                  );
                }
              },

              child: const Text('Continuar con Google'),
            ),

            const SizedBox(height: 12),

            // EMAIL + PASSWORD (pantalla aparte)
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Crear cuenta con email'),
            ),

            const Spacer(),

            // Salida segura
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ahora no'),
            ),
          ],
        ),
      ),
    );

    return ResponsiveLayout(rightChild: rightContent, leftChild: Container());
  }
}
