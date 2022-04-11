// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_conection/models/chatting_model.dart';
import 'package:flutter/material.dart';

class ChattingProvider extends ChangeNotifier {
  ChattingProvider(this.pk, this.name, this.room);
  final String pk;
  final String name;
  final String room;

  late String CHATTING_ROOM = room;
  var chattingList = <ChattingModel>[];

//--------- Firebase 실시간 연동시켜주는 기능 ---------------
  Stream<QuerySnapshot> getSnapshot() {
    final f = FirebaseFirestore.instance;
    return f
        .collection(CHATTING_ROOM)
        .limit(1)
        .orderBy('uploadTime', descending: true)
        .snapshots();
  }

  void addOne(ChattingModel model) {
    chattingList.insert(0, model);
    notifyListeners();
  }
// ----------------------------------

  Future create() async {
    var now = DateTime.now().microsecondsSinceEpoch;
    final f = FirebaseFirestore.instance;
    await f
        .collection(CHATTING_ROOM)
        .doc(now.toString())
        .set({'name': '', 'pk': '', 'text': '', 'uploadTime': now});
  }

  Future load() async {
    print('로드들어옴');
    var now = DateTime.now().millisecondsSinceEpoch;
    final f = FirebaseFirestore.instance;
    var result = await f
        .collection(CHATTING_ROOM)
        .where(
          'uploadTime',
          isGreaterThan: now,
        )
        .orderBy('uploadTime', descending: true)
        .get();
    var l = result.docs
        .map((e) => ChattingModel.fromJson(e.data()))
        .toList(); // Json형태로 들어옴
    chattingList.addAll(l); // Json데이터를 chattingModel의 리스트형식으로 추가
    notifyListeners();
  }

  Future send(String text) async {
    var now = DateTime.now().microsecondsSinceEpoch;
    final f = FirebaseFirestore.instance;
    await f
        .collection(CHATTING_ROOM)
        .doc(now.toString())
        .set(ChattingModel(pk, name, text, now).toJson());
  }
}
