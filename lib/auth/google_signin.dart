import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screen/profile_screen/add_profile_screen.dart';

class GoogleSignin extends StatelessWidget {
  const GoogleSignin({Key? key}) : super(key: key);

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // サインインが成功した後に画面遷移する
      if (userCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProfile()),
        );
      }
    } catch (e) {
      // サインインが失敗した場合のエラーハンドリング
      print('Sign in with Google failed: $e');
      // エラーの表示など、適切な処理を行ってください
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Login')),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                signInWithGoogle(context);
              },
              child: const Text('Google'),
            ),
          ],
        ),
      ),
    );
  }
}
