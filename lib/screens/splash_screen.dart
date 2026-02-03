import 'package:flutter/material.dart';
import 'write_screen.dart';
import '../widgets/responsive_layout.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rightContent = Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Intime', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            Text(
              'Un espacio privado para escribir lo que no dices en voz alta.\n\n'
              'Tus palabras no son para ahora.\n\n'
              'Son para después.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const WriteScreen()),
                );
              },
              child: const Text('Empezar a escribir'),
            ),
          ],
        ),
      ),
    );

    return ResponsiveLayout(
      rightChild: rightContent,
      leftChild: Container(), // Left side is currently black/empty
    );
  }
}
