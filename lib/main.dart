import 'package:flutter/material.dart';
import '5120185055/login.dart';

void main()
{
  runApp(
      SelectStudent()
  );
}

class SelectStudent extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '实验二',
      home: Scaffold(
        appBar: AppBar(
          title: Text('第二组实验一'),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Login5055()));
                    },
                    child: Text('5120185055赵付邦')
                ),
                ElevatedButton(
                    onPressed: () {
                      
                    },
                    child: Text('5120185068徐世庆')
                ),
              ],
            )
          );
        },)
      ),
      theme: ThemeData(
        primarySwatch: Colors.pink
      ),
    );
  }
}