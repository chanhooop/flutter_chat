import 'dart:async';
import 'dart:convert';

import 'package:firebase_conection/models/chatting_model.dart';
import 'package:firebase_conection/screens/chatting_page/local_utils/ChattingProvider.dart';
import 'package:firebase_conection/screens/chatting_page/local_widget/chatting_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({Key? key}) : super(key: key);

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  late TextEditingController _controller;
  late StreamSubscription _streamSubscription;
  bool firstLoad = true;

  @override
  void initState() {
    _controller = TextEditingController();
    var p = Provider.of<ChattingProvider>(context, listen: false);
    // microtask를 쓰면 앱화면이 빌드가 완료되고 실행시켜서 안정적이다 / 최초데이터 가져오기
    Future.microtask(() => p.load());
    // firebase 실시간 연동 시키기
    _streamSubscription = p.getSnapshot().listen(
      (event) {
        p.addOne(ChattingModel.fromJson(
            event.docs[0].data() as Map<String, dynamic>));
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    // firebase와의 연동을 끊어주기
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<ChattingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                reverse: true, //밑에서 위로 채워지게
                children: p.chattingList
                    .map((e) => ChattingItem(chattingModel: e))
                    .toList(),
              ),
            ),
            const Divider(
              thickness: 1,
              height: 1.5,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                // constraints 로 올라가는 최대 높이 설정가능
                constraints: BoxConstraints(
                  //최대높이
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        // 줄바꿈 되게 만들기
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(fontSize: 25),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '텍스트 입력',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        var text = _controller.text;
                        _controller.text = ''; // 보내기 누르고 입력한 글자 없애주기
                        p.send(text);
                      },
                      child: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
