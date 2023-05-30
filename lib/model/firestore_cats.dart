import 'package:cloud_firestore/cloud_firestore.dart';

// catsテーブルの定義
class Cats {
  String id;       //←SQLiteの時はintだったが、Firestoreでは特に使わないのでStringに変更
  String name;
  String gender;
  String birthday;
  String memo;
  DateTime? createdAt;  //←SQLiteでは自動で設定されたが、Firestoreではそういう機能はなく、自力で設定する

  Cats({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthday,
    required this.memo,
    required this.createdAt,
  });
// ↓公式ドキュメントを参考に、以下の処理を追加
  factory Cats.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Cats(
        id: data?['id'],
        name: data?['name'],
        gender: data?['gender'],
        birthday: data?['birthday'],
        memo: data?['memo'],
        createdAt: data?['createdAt'].toDate());
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "gender": gender,
      "birthday": birthday,
      "memo": memo,
      "createdAt": createdAt,
    };
  }
//↑追加ここまで
// copy,fromJson,toJsonは削除
}