import 'package:flutter/material.dart';
import '../state/draft_state.dart';
import '../widgets/responsive_layout.dart';
import '../auth/protect_words_screen.dart';
import '../auth/auth_service.dart';
import '../models/message.dart';
import '../state/messages_store.dart';
import 'package:uuid/uuid.dart';
import 'home_screen.dart';

class WriteScreen extends StatefulWidget {
  final Message? message;

  const WriteScreen({super.key, this.message});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final DraftState draft = DraftState();
  final TextEditingController controller = TextEditingController();
  final AuthService _authService = AuthService();

  bool isForSomeone = false;
  final TextEditingController audienceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.message != null) {
      draft.text = widget.message!.text;
      controller.text = draft.text;

      if (widget.message!.audienceLabel != null) {
        isForSomeone = true;
        audienceController.text = widget.message!.audienceLabel!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rightContent = Scaffold(
      appBar: AppBar(title: const Text('Escribe')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Checkbox: escribir para alguien
            Row(
              children: [
                Checkbox(
                  value: isForSomeone,
                  onChanged: (value) {
                    setState(() {
                      isForSomeone = value ?? false;
                      if (!isForSomeone) {
                        audienceController.clear();
                      }
                    });
                  },
                ),
                const Text('Escribir para alguien'),
              ],
            ),

            // Campo audiencia
            if (isForSomeone)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: audienceController,
                  decoration: const InputDecoration(
                    labelText: '¿Para quién es?',
                    hintText: 'Ej: Mamá, Papá, Hijo, Pareja…',
                  ),
                ),
              ),

            // Editor principal
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Escribe lo que no dices en voz alta...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  draft.text = value;
                },
              ),
            ),

            const SizedBox(height: 12),

            // BOTÓN GUARDAR
            ElevatedButton(
              onPressed: () async {
                // Validación mínima
                if (draft.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Escribe algo antes de guardar'),
                    ),
                  );
                  return;
                }

                // 🔒 Crear usuario anónimo SOLO AQUÍ (si hace falta)
                final user = await _authService.ensureAnonymousUser();

                final now = DateTime.now();

                final message = widget.message != null
                    ? widget.message!.copyWith(
                        text: draft.text,
                        updatedAt: now,
                        audienceLabel: isForSomeone
                            ? audienceController.text.trim()
                            : null,
                      )
                    : Message(
                        id: const Uuid().v4(),
                        text: draft.text,
                        ownerId: user.uid,
                        audienceLabel: isForSomeone
                            ? audienceController.text.trim()
                            : null,
                        createdAt: now,
                        updatedAt: now,
                      );

                await MessagesStore().save(message);

                // Limpiar draft
                draft.text = '';
                controller.clear();
                audienceController.clear();
                isForSomeone = false;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mensaje guardado')),
                );

                // 👉 Pedir proteger palabras (upgrade de cuenta)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProtectWordsScreen()),
                );
              },
              child: Text(
                widget.message != null ? 'Guardar cambios' : 'Guardar mensaje',
              ),
            ),
          ],
        ),
      ),
    );

    return ResponsiveLayout(rightChild: rightContent, leftChild: Container());
  }
}
