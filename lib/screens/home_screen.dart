import 'package:flutter/material.dart';
import '../widgets/responsive_layout.dart';
import '../state/messages_store.dart';
import '../models/message.dart';
import 'write_screen.dart';
import '../auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'write_screen.dart';
import 'splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  void _handleMenuAction(BuildContext context, _HomeMenuOption option) {
    switch (option) {
      // case _HomeMenuOption.home:
      //   // ya estamos en home → no hacemos nada
      //   break;

      case _HomeMenuOption.newMessage:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WriteScreen()),
        );
        break;

      case _HomeMenuOption.logout:
        _confirmLogout();
        break;
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text(
            '¿Seguro que quieres salir?\nTus mensajes seguirán aquí.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await _logout();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _logout() async {
    final navigator = Navigator.of(context);

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (route) => false,
    );
  }

  Future<void> _loadMessages() async {
    final user = _authService.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

    await MessagesStore().load(user.uid);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = MessagesStore().messages;

    final rightContent = Scaffold(
      appBar: AppBar(
        title: const Text('Intime'),
        actions: [
          PopupMenuButton<_HomeMenuOption>(
            icon: const Icon(Icons.more_vert),
            onSelected: (option) {
              _handleMenuAction(context, option);
            },
            itemBuilder: (context) => const [
              // PopupMenuItem(value: _HomeMenuOption.home, child: Text('Home')),
              PopupMenuItem(
                value: _HomeMenuOption.newMessage,
                child: Text('Nuevo mensaje'),
              ),
              PopupMenuItem(
                value: _HomeMenuOption.logout,
                child: Text('Cerrar sesión'),
              ),
            ],
          ),
        ],
      ),

      body: _isLoading
          ? const _LoadingState()
          : messages.isEmpty
          ? _EmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final message = messages[index];
                return _MessageTile(message: message);
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WriteScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );

    return ResponsiveLayout(leftChild: Container(), rightChild: rightContent);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aquí aparecerán tus mensajes.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Escribe sin prisa.\nNo son para ahora.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  final Message message;

  const _MessageTile({required this.message});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => WriteScreen(message: message)),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.audienceLabel ?? 'Solo para mí',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                message.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _HomeMenuOption { newMessage, logout }

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
