import 'package:app4/public%20class/XieHouYu.dart';
import 'package:flutter/material.dart';
import 'package:app4/5120185055/PageNews.dart';
import 'package:app4/5120185055/userInfo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int crtIndex = 0;
  var scaffoldcolor = [Colors.white, Colors.blue];
  final page_bottom = [PageNews(), UserInfo()];
  List<XieHouYu> _datas = [];
  bool cancelConnect = false;

  @override
  void initState() {
    super.initState();
    isConnected().then((value) {
      if(value)
        _getDatas();
      else
        Fluttertoast.showToast(msg: "未连接网络", backgroundColor: Colors.blue, textColor: Colors.white);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldcolor[crtIndex],
      appBar: AppBar(
        title: Text("新闻浏览器"),
        actions: [
          IconButton(icon: Icon(Icons.help), onPressed: () => showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  title: Icon(Icons.info),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("“新闻”主要用于显示多条图、文的新闻信息."),
                      Text("“我的”用于显示当前登录用户的个人信息.")
                    ],
                  )
                );
              }
            )),
          IconButton(icon: Icon(Icons.assistant_rounded), onPressed: () {
            isConnected().then((value) {
              if(value)
              {
                showDialog(context: context, builder: (BuildContext context) {
                  _getDatas();
                  return AlertDialog(
                    title: Icon(Icons.auto_awesome),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_datas[0].last),
                        Text(_datas[0].next)
                      ],
                    )
                  );
                });
              }
              else
                Fluttertoast.showToast(msg: "未连接网络", backgroundColor: Colors.blue, textColor: Colors.white);
            });
          })
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.description), label: "新闻"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: "我的")
        ],
        currentIndex: crtIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            crtIndex = index;
          });
        },
      ),
      body: page_bottom[crtIndex],
    );
  }

  _getDatas()
  {
    getDatas().then((List<XieHouYu> datas) {
      if(!cancelConnect)
        setState(() => _datas = datas);
    }).catchError((e) => print("error: $e"))
      .whenComplete(() => print("complete"))
      .timeout(Duration(seconds: 5))
      .catchError((timeOut) {
        print("time out: $timeOut");
        cancelConnect = true;
      });
  }
}

Future<List<XieHouYu>> getDatas() async {
  final response = await http.get(Uri.parse("http://api.tianapi.com/txapi/xiehou/index?key=270c6a59f57d94370ed1f3a3f9af3c68&num=1"));
  Utf8Decoder decoder = new Utf8Decoder();
  Map<String, dynamic> result = jsonDecode(decoder.convert(response.bodyBytes));
  List<XieHouYu> datas;
  datas = result["newslist"].map<XieHouYu>((item) => XieHouYu.fromJson(item)).toList();
  return datas;
}