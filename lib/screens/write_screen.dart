import 'package:flutter/material.dart';
import '../state/draft_state.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final DraftState draft = DraftState();
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = draft.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escribe')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Escribe aquí...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  draft.text = value;
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Aquí luego pondremos el flujo de login + guardado
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
