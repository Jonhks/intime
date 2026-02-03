import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class MessagesRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return _db.collection('users').doc(userId).collection('messages');
  }

  Future<void> saveMessage(Message message) async {
    await _collection(message.ownerId).doc(message.id).set(message.toMap());
  }

  Future<List<Message>> fetchMessages(String userId) async {
    final snapshot = await _collection(
      userId,
    ).orderBy('updatedAt', descending: true).get();

    return snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
  }
}
