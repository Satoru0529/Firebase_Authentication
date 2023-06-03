import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../domain/message.dart';
import '../../model/firebase_service.dart';
import 'chat_answer_screen.dart';

class ChatQuestionScreen extends StatefulWidget {
  @override
  _ChatQuestionScreenState createState() => _ChatQuestionScreenState();
}

class _ChatQuestionScreenState extends State<ChatQuestionScreen> {
  TextEditingController _textEditingController = TextEditingController();
  String _response = '';

  Future<String> sendQuestion(String question) async {
    //final apiUrl = 'https://api.openai.com/v1/engines/davinci-codex/completions';
    final apiKeyDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final apiKey = apiKeyDoc.data()!['APIkey'] as String;

    final apiUrl = 'https://api.openai.com/v1/engines/davinci/completions';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    final body = {
      'prompt': '$question\nA:',
      'max_tokens': 50,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['text'];
    } else {
      throw Exception("Failed to send question.");
    }
  }

  void _sendMessage() async {
    String question = _textEditingController.text.trim();
    if (question.isNotEmpty) {
      // ChatGPTのAPI呼び出し
      String answer = await sendQuestion(question);
      // Firestoreにメッセージを保存
      Message message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        question: question,
        answer: answer,
      );
      await FirebaseService.saveMessage(message);

      // AnswerScreenに遷移
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatAnswerScreen(answer: message.answer),
        ),
      );

      // テキストフィールドをクリア
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Chat'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Ask a question',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
