import 'package:cloud_firestore/cloud_firestore.dart'; //←追加
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/firestore_cats.dart';
import '../model/firestore_helper.dart';
import 'cat_detail.dart';
import 'cat_detail_edit.dart';

// catテーブルの内容全件を一覧表示するクラス
class CatList extends StatefulWidget {
  const CatList({Key? key}) : super(key: key);

  @override
  _CatListPageState createState() => _CatListPageState();
}

class _CatListPageState extends State<CatList> {
  List<DocumentSnapshot> catSnapshot = []; //←firestore_helperからの戻り値の型がDocumentsnapshotなので、それを受ける項目を追加
  List<Cats> catList = []; //catsテーブルの全件を保有する
  bool isLoading = false;
  //static const String userId = 'test@apricotcomic.com'; //仮のユーザID。認証機能を実装したら、本物のIDに変更する。

  @override
  void initState() {
    super.initState();
    getCatsList();
  }

// catsテーブルに登録されている全データを取ってくる
  Future getCatsList() async {
    setState(() => isLoading = true);
    catSnapshot = await FirestoreHelper.instance
        .selectAllCats(FirebaseAuth.instance.currentUser!.uid); //←users配下のcatsコレクションのドキュメントを全件読み込む
    catList = catSnapshot //←受け取ったDocumentsnapshotの値をListに変換する
        .map((doc) => Cats(
        id: doc['id'],
        name: doc['name'],
        gender: doc['gender'],
        birthday: doc['birthday'],
        memo: doc['memo'],
        createdAt: doc['createdAt'].toDate()))  //←dartのdatetime型をfirestoreのtimestamp型に変換するため.toDateを追加
        .toList();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('猫一覧')),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SizedBox(
        child: ListView.builder(
          itemCount: catList.length,
          itemBuilder: (BuildContext context, int index) {
            final cat = catList[index]; //←List変換しているので、SQLiteの時の処理を変更なしでそのまま使える
            return Card(
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                      children: <Widget>[
                        Container(
                            width: 80,height: 80,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage('assets/icon/dora.png')
                                )
                            )
                        ),
                        Text(cat.name,style: const TextStyle(fontSize: 30),),
                      ]
                  ),
                ),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CatDetail(userId: FirebaseAuth.instance.currentUser!.uid,name: cat.name),
                    ),
                  );
                  getCatsList();
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => CatDetailEdit(userId: FirebaseAuth.instance.currentUser!.uid, cats: null,) //←CatDetailEditに渡す値にuserIdを追加。これをキーにusersコレクションにアクセスする
            ),
          );
          getCatsList();
        },
      ),
    );
  }
}