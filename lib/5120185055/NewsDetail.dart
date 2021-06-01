import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NewsDetail extends StatefulWidget {
  final String url;
  final String title;

  NewsDetail({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  bool loaded = false;
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((event) {
      print('state: ${event.type}');
      if(event.type == WebViewState.finishLoad)
        setState(() {
          loaded = true;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> title = [];
    title.add(Text(widget.title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13),));
    if(!loaded)
      title.add(CupertinoActivityIndicator());
    title.add(Container(width: 50));
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        title: Expanded(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: title,
        ),),
      ),
      withZoom: true,
      withLocalStorage: true,
      withJavascript: true,
    );
  }
}