import 'package:flutter/material.dart';

import '../model/firestore_cats.dart';
import '../model/firestore_helper.dart'; //←db_helperを変更

class CatDetailEdit extends StatefulWidget {
  final String userId; //←追加
  final Cats? cats;

  const CatDetailEdit({Key? key,required this.userId, this.cats}) : super(key: key); //←userIdも受け取るよう変更

  @override
  _CatDetailEditState createState() => _CatDetailEditState();
}

class _CatDetailEditState extends State<CatDetailEdit> {
  late String id; //←Stringに変更しました。根拠はない。数字だと面倒だから。
  late String name;
  late String birthday;
  late String gender;
  late String memo;
  late DateTime createdAt;
  final List<String> _list = <String>['男の子', '女の子', '不明'];
  late String _selected;
  String value = '不明';
  static const int textExpandedFlex = 1;
  static const int dataExpandedFlex = 4;

  @override
  void initState() {
    super.initState();
    id = widget.cats?.id ?? ''; //←Stringに変更したので、初期値も変更
    name = widget.cats?.name ?? '';
    birthday = widget.cats?.birthday ?? '';
    gender = widget.cats?.gender ?? '';
    _selected = widget.cats?.gender ?? '不明';
    memo = widget.cats?.memo ?? '';
    createdAt = widget.cats?.createdAt ?? DateTime.now();
  }

  void _onChanged(String? value) {
    setState(() {
      _selected = value!;
      gender = _selected;
    });
  }

// 詳細編集画面を表示する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('猫編集'),
        actions: [
          buildSaveButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Row(children: [
            // 名前の行の設定
            const Expanded(
              flex: textExpandedFlex,
              child: Text('名前',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: dataExpandedFlex,
              child: TextFormField(
                maxLines: 1,
                initialValue: name,
                decoration: const InputDecoration(
                  hintText: '名前を入力してください',
                ),
                validator: (name) => name != null && name.isEmpty
                    ? '名前は必ず入れてね'
                    : null,
                onChanged: (name) => setState(() => this.name = name),
              ),
            ),
          ]),
          Row(children: [
            const Expanded(
              flex: textExpandedFlex,
              child: Text('性別',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: dataExpandedFlex,
              child: DropdownButton(
                items: _list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: _selected,
                onChanged: _onChanged,
              ),
            ),
          ]),
          Row(children: [
            const Expanded(
              flex: textExpandedFlex,
              child: Text('誕生日',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: dataExpandedFlex,
              child: TextFormField(
                maxLines: 1,
                initialValue: birthday,
                decoration: const InputDecoration(
                  hintText: '誕生日を入力してください',
                ),
                onChanged: (birthday) =>
                    setState(() => this.birthday = birthday),
              ),
            ),
          ]),
          Row(children: [
            const Expanded(
                flex: textExpandedFlex,
                child: Text('メモ',
                  textAlign: TextAlign.center,
                )
            ),
            Expanded(
              flex: dataExpandedFlex,
              child: TextFormField(
                maxLines: 1,
                initialValue: memo,
                decoration: const InputDecoration(
                  hintText: 'メモを入力してください',
                ),
                onChanged: (memo) => setState(() => this.memo = memo),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget buildSaveButton() {
    final isFormValid = name.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        child: const Text('保存'),
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? Colors.redAccent : Colors.grey.shade700,
        ),
        onPressed: createOrUpdateCat,
      ),
    );
  }

  void createOrUpdateCat() async {
    final isUpdate = (widget.cats != null);

    if (isUpdate) {
      await updateCat();
    } else {
      await createCat();
    }

    Navigator.of(context).pop();
  }

  // 更新処理の呼び出し
  Future updateCat() async {
    final cat = Cats( //←画面から項目をもってきていたが、渡されたCatsからセットするよう変更
      id: id, //←値はないけど、一応追加
      name: name,
      birthday: birthday,
      gender: gender,
      memo: memo,
      createdAt: createdAt,
    );

    await FirestoreHelper.instance.insert(cat, widget.userId); //←userIdを追加
  }

  // 追加処理の呼び出し
  Future createCat() async {
    final cat = Cats(
      id: id, //←値はないけど、一応追加
      name: name,
      birthday: birthday,
      gender: gender,
      memo: memo,
      createdAt: createdAt,
    );
    await FirestoreHelper.instance.insert(cat, widget.userId);  //←userIdを追加
  }
}