import '../models/message.dart';
import '../data/messages_repository.dart';

class MessagesStore {
  static final MessagesStore _instance = MessagesStore._internal();
  factory MessagesStore() => _instance;
  MessagesStore._internal();

  MessagesRepository? _repository;
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  MessagesRepository get repository {
    _repository ??= MessagesRepository();
    return _repository!;
  }

  Future<void> load(String userId) async {
    _messages = await repository.fetchMessages(userId);
  }

  Future<void> save(Message message) async {
    await repository.saveMessage(message);
    await load(message.ownerId);
  }
}
