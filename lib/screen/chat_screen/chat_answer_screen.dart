import 'package:flutter/material.dart';

class ChatAnswerScreen extends StatelessWidget {
  final String answer;

  ChatAnswerScreen({required this.answer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer'),
      ),
      body: Center(
        child: Text(answer),
      ),
    );
  }
}