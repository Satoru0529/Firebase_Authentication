import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_cats.dart'; //←追加します

// catsテーブルへのアクセスをまとめたクラス
class FirestoreHelper {
  // DbHelperをinstance化する
  static final FirestoreHelper instance = FirestoreHelper._createInstance();

  FirestoreHelper._createInstance();

  // catsテーブルのデータを全件取得する
  selectAllCats(String userId) async {
    final db = FirebaseFirestore.instance;
    //↓catsコレクションにあるdocを全て取得する
    //　この時、fromFirestore、toFirestoreを使ってデータ変換する
    final snapshot =
    db.collection("users").doc(userId).collection("cats").withConverter(
      fromFirestore: Cats.fromFirestore,
      toFirestore: (Cats cats, _) => cats.toFirestore(),
    );
    final cats = await snapshot.get();
    return cats.docs;
  }

// nameをキーにして1件のデータを読み込む
// ※catsのキーはidでなくnameに変更している
  catData(String userId, String name) async {
    final db = FirebaseFirestore.instance;
    final docRef = db
        .collection("users")
        .doc(userId)
        .collection("cats")
        .doc(name)
        .withConverter(
      fromFirestore: Cats.fromFirestore,
      toFirestore: (Cats cats, _) => cats.toFirestore(),
    );
    final catdata = await docRef.get();
    final cat = catdata.data();
    return cat;
  }

// データをinsertする
// ※updateも同じ処理で行うことができるので、共用している
  Future insert(Cats cats, String userId) async {
    final db = FirebaseFirestore.instance;
    final docRef = db
        .collection("users")
        .doc(userId)
        .collection("cats")
        .doc(cats.name)
        .withConverter(
      fromFirestore: Cats.fromFirestore,
      toFirestore: (Cats cats, options) => cats.toFirestore(),
    );
    await docRef.set(cats);
  }

// データを削除する
  Future delete(String userId, String name) {
    final db = FirebaseFirestore.instance;
    return db
        .collection("users")
        .doc(userId)
        .collection("cats")
        .doc(name)
        .delete();
  }
}