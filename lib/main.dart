import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_agi/view/cat_list.dart';
import 'auth/google_signin.dart';
import 'firebase_options.dart';
import 'list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();   //Firebase初期化処理　ここから
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );                                           //Firebase初期化処理　ここまで
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter app',
    home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // スプラッシュ画面などに書き換えても良い
          return const SizedBox();
        }
        if (snapshot.hasData) {
          // User が null でなない、つまりサインイン済みのホーム画面へ
          return MyList();
        }
        // User が null である、つまり未サインインのサインイン画面へ
        return GoogleSignin();
      },
    ),
  );
}