import 'package:app4/databass/TableNews.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app4/public%20class/ScienceNew.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'NewsDetail.dart';
import 'package:path/path.dart';
import 'package:connectivity/connectivity.dart';

List<ScienceNew> _datas = [];
bool connect = false;

class PageNews extends StatefulWidget {
  const PageNews({Key? key}) : super(key: key);

  @override
  _PageNewsState createState() => _PageNewsState();
}

class _PageNewsState extends State<PageNews> {
  int page = 1;

  @override
  initState() {
    super.initState();
    isConnected().then((value) {
      if(connect)
        _getDatas();
      else
        _querySQLHelper_read();
    }).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: ListView.builder(itemCount: _datas.length, itemBuilder: (BuildContext context, int id) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 1, color: Colors.pink)),
            boxShadow: [BoxShadow(blurRadius: 2, color: Colors.pinkAccent[100]!)]
          ),
          padding: EdgeInsets.all(10),
          child: InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(20),),
                  clipBehavior: Clip.antiAlias,
                  child: ImageError(id: id,)
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(_datas[id].title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
                Padding(
                  padding: _datas[id].description.isEmpty ? EdgeInsets.all(0) : EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Text(_datas[id].description, style: TextStyle(fontSize: 12),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text("时间: ${_datas[id].ctime}", style: TextStyle(fontSize: 12, color: Colors.grey),),  
                )
              ],
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsDetail(url: _datas[id].url, title: _datas[id].title,))),
          ),
        )),
        onRefresh: () async{
          await isConnected().then((value) {
            if(connect)
            {
              _datas.clear();
              _getDatas();
            }
          });
        }
    );
  }

  _getDatas() {
    getDatas(page).then((List<ScienceNew> datas) {
      setState(() => _datas = datas);
      _querySQLHelper_write(datas);
    }).catchError((e) => print("error: $e"))
        .whenComplete(() => print("complete"))
        .timeout(Duration(seconds: 5))
        .catchError((timeOut) {
      print("time out: $timeOut");
    });
    page++;
  }
  Future<List<ScienceNew>> getDatas(int page) async {
    final response = await http.get(Uri.parse("http://api.tianapi.com/sicprobe/index?key=270c6a59f57d94370ed1f3a3f9af3c68&num=10&page=" + page.toString()));
    Utf8Decoder decoder = new Utf8Decoder();
    Map<String, dynamic> result = jsonDecode(decoder.convert(response.bodyBytes));
    List<ScienceNew> datas;
    datas = result["newslist"].map<ScienceNew>((item) => ScienceNew.fromJson(item)).toList();
    return datas;
  }

  _querySQLHelper_write(List<ScienceNew> datas) async {
    TNewsProvider tNewsProvider = TNewsProvider();
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, "app4.db");
    await tNewsProvider.open(path);
    for(int i = 0; i < 10; i++)
    {
      TNews tNews = new TNews(id: i, ctime: datas[i].ctime, title: datas[i].title, description: datas[i].description, picUrl: datas[i].picurl, url: datas[i].url);
      await tNewsProvider.update(tNews);
    }
    tNewsProvider.close();
  }
  _querySQLHelper_read() async {
    TNewsProvider tNewsProvider = TNewsProvider();
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, "app4.db");
    await tNewsProvider.open(path);
    for(int i = 0; i < 10; i++)
    {
      TNews tNews = await tNewsProvider.select(i);
      ScienceNew scienceNew = new ScienceNew(ctime: tNews.ctime!, description: tNews.description!, picurl: tNews.picUrl, title: tNews.title!, url: tNews.url!);
      _datas.add(scienceNew);
    }
    tNewsProvider.close();
  }

  
}

class ImageError extends StatelessWidget {
  int id;
  
  ImageError({required this.id});

  @override
  Widget build(BuildContext context) {
    if (connect)
      return Image.network(_datas[id].picurl!, fit: BoxFit.fitWidth, width: double.infinity,);
    else
      return Center(child:Icon(Icons.error_rounded));
  }
}

Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  connect = (connectivityResult != ConnectivityResult.none);
  return connect;
}