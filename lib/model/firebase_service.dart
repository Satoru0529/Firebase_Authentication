import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/message.dart';

class FirebaseService {
  static Future<void> saveMessage(Message message) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chat");
    await collection.doc(message.id).set({
      'question': message.question,
      'answer': message.answer,
    });
  }

  static Future<List<Message>> loadMessages() async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chat");
    final querySnapshot = await collection.get();
    final messages = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Message(
        id: doc.id,
        question: data['question'],
        answer: data['answer'],
      );
    }).toList();
    return messages;
  }
}
