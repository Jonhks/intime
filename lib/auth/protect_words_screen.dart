import 'package:flutter/material.dart';
import '../widgets/responsive_layout.dart';
import '../screens/login_screen.dart';

class ProtectWordsScreen extends StatelessWidget {
  const ProtectWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rightContent = Scaffold(
      appBar: AppBar(
        title: const Text('Protege tus palabras'),
        automaticallyImplyLeading: true, // permite volver atrás
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

            // Texto explicativo (clave)
            Text(
              'Para que este mensaje no se pierda y solo tú puedas editarlo, '
              'necesitamos asociarlo a una cuenta segura.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 32),

            // Acción principal: Google
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              child: const Text('Entrar (temporal)'),
            ),

            const SizedBox(height: 12),

            // Acción secundaria: Email
            OutlinedButton(
              onPressed: () {
                // aquí luego irá email + password
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

    return ResponsiveLayout(
      rightChild: rightContent,
      leftChild: Container(), // lado visual, luego lo decoramos
    );
  }
}
