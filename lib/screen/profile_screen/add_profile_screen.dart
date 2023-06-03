import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../chat_screen/chat_history_screen.dart';

class AddProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Add Sample',
      home: AddProfileScreen(),
    );
  }
}

class AddProfileScreen extends StatefulWidget {
  @override
  _AddProfileScreenState createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final apikeyController = TextEditingController();
  String name = "";
  String age = "";
  String apikey = "";

  @override
  Widget build(BuildContext context) {
    //CollectionReference users = FirebaseFirestore.instance.collection('users');
    //DocumentReference users = FirebaseFirestore.instance.doc("documentPath");

    DocumentReference users = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    Future<void> addFirestoreUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .set({'name': name, 'age': age, 'APIkey': apikey})
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'プロフィール情報を入力して下さい',
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: '名前',
              ),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                hintText: '年齢',
              ),
            ),
            TextField(
              controller: apikeyController,
              decoration: InputDecoration(
                hintText: 'APIkey',
              ),
            ),
            TextButton(
              child: Text('新規登録'),
              onPressed: () {
                name = nameController.text;
                age = ageController.text;
                apikey = apikeyController.text;
                addFirestoreUser();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatHistoryScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
