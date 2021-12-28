import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_conection/screens/chatting_page/chatting_page.dart';
import 'package:firebase_conection/screens/chatting_page/local_utils/ChattingProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EntrancePage extends StatefulWidget {
  const EntrancePage({Key? key}) : super(key: key);

  @override
  State<EntrancePage> createState() => _EntrancePageState();
}

class _EntrancePageState extends State<EntrancePage> {
  late TextEditingController _nameController,
      _creatRoomController,
      _enterRoomController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _creatRoomController = TextEditingController();
    _enterRoomController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var u = const Uuid().v1();
    print('u : $u');
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
                controller: _nameController,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '닉네임 입력',
                    hintStyle: TextStyle(color: Colors.grey))),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
                controller: _enterRoomController,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '입장할 방이름 입력',
                    hintStyle: TextStyle(color: Colors.grey))),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                      create: (context) => ChattingProvider(
                          u, _nameController.text, _enterRoomController.text),
                      child: const ChattingPage())));
/*
              final f = FirebaseFirestore.instance;
              f.collection('CHATTING_ROOM').doc('abc').set({'abc??': '나나나'});
              print('끝?');
*/
            },
            child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey)),
                child: const Text(
                  '방입장하기',
                  style: TextStyle(fontSize: 25),
                )),
          ),

          // ===========================================

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
                controller: _creatRoomController,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '방이름 입력',
                    hintStyle: TextStyle(color: Colors.grey))),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                      create: (context) => ChattingProvider(u,
                          _creatRoomController.text, _creatRoomController.text),
                      child: const ChattingPage())));
/*
              final f = FirebaseFirestore.instance;
              f.collection('CHATTING_ROOM').doc('abc').set({'abc??': '나나나'});
              print('끝?');
*/
            },
            child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey)),
                child: const Text(
                  '방 만들기',
                  style: TextStyle(fontSize: 25),
                )),
          ),
        ],
      ),
    ));
  }
}
