import 'package:flutter/material.dart';

import '../../domain/message.dart';

class ChatDetailScreen extends StatelessWidget {
  final Message message;

  ChatDetailScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(message.question),
            SizedBox(height: 16.0),
            Text('Answer:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(message.answer),
          ],
        ),
      ),
    );
  }
}