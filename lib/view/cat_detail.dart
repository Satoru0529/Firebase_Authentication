import 'package:flutter/material.dart';

import '../model/firestore_cats.dart';
import '../model/firestore_helper.dart';
import 'cat_detail_edit.dart';

// catsテーブルの中の1件のデータに対する操作を行うクラス
class CatDetail extends StatefulWidget {
  final String userId;  //←追加
  final String name;  //←catsコレクションのキーをnameにしたので、idからnameに変更した

  const CatDetail({Key? key, required this.userId, required this.name}) //←userIdを追加、idをnameに変更
      : super(key: key);

  @override
  _CatDetailState createState() => _CatDetailState();
}

class _CatDetailState extends State<CatDetail> {
  late Cats cats;
  bool isLoading = false;
  static const int textExpandedFlex = 1;
  static const int dataExpandedFlex = 4;

  @override
  void initState() {
    super.initState();
    catData();
  }

// catsコレクションから指定されたnameのデータを1件取得する
  Future catData() async {
    setState(() => isLoading = true);
    cats = await FirestoreHelper.instance.catData(widget.userId, widget.name); //←firestore_helperに変更。userIdとnameを渡すよう変更
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('猫詳細'),
          actions: [
            IconButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CatDetailEdit(
                      cats: cats,
                      userId: widget.userId, //←userIdを追加
                    ),
                  ),
                );
                catData();
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () async {
                await FirestoreHelper.instance
                    .delete(widget.userId, widget.name); //←firestore_helperに変更。渡userId,nameを渡すよう変更
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete),
            )
          ],
        ),
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          children :[
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  const Expanded(
                    flex: textExpandedFlex,
                    child: Text('名前',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: dataExpandedFlex,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(cats.name),
                    ),
                  ),
                ],),
                Row(children: [
                  const Expanded(
                    flex: textExpandedFlex,
                    child: Text('性別',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: dataExpandedFlex,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(cats.gender),
                    ),
                  ),
                ],),
                Row(children: [
                  const Expanded(
                    flex: textExpandedFlex,
                    child: Text('誕生日',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: dataExpandedFlex,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(cats.birthday),
                    ),
                  )
                ],),
                Row(children: [
                  const Expanded(
                      flex: textExpandedFlex,
                      child: Text('メモ',
                        textAlign: TextAlign.center,
                      )
                  ),
                  Expanded(
                    flex: dataExpandedFlex,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(cats.memo),
                    ),
                  ),
                ],),
              ],
            ),
          ],
        )
    );
  }
}