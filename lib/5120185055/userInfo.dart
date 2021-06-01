import 'package:app4/5120185055/login.dart';
import 'package:app4/databass/TableUser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'submit.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  TextEditingController password_old = new TextEditingController();
  TextEditingController password_new = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.7,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height:
                                0.1 * 0.8 * MediaQuery.of(context).size.height,
                            child: Icon(
                              Icons.account_circle_outlined,
                              color: Colors.blue,
                              size: 64,
                            ),
                          ),
                          Text("等级：    " + user.level.toString()),
                          Text("姓名：    " + user.name),
                          Text("年龄：    " + user.age.toString()),
                          Text("性别：    " + user.sex),
                          Text("邮箱：    " + user.email),
                          Text("密码：    " + user.password),
                          ElevatedButton(
                            child: Text("修改密码"),
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(Size(100, 30)),
                              backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              overlayColor: MaterialStateProperty.all(Colors.blueAccent[100]),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
                            ),
                            onPressed: (){
                              showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Passwordinput(hint: "请输入旧密码", textEditingController: password_old),
                                        Passwordinput(hint: "请输入新密码", textEditingController: password_new),
                                      ],
                                    )
                                  ),
                                  actions: [
                                    IconButton(
                                      onPressed: (){
                                        if (password_old.text == password_new.text)
                                          Fluttertoast.showToast(msg: "新密码与旧密码相同", backgroundColor: Colors.blue, textColor: Colors.white);
                                        if (password_old.text != user.password)
                                          Fluttertoast.showToast(msg: "旧密码有误", backgroundColor: Colors.blue, textColor: Colors.white);
                                        else
                                        {
                                          user.password = password_new.text;
                                          _querySQLHelper();
                                          Fluttertoast.showToast(msg: "更改成功", backgroundColor: Colors.blue, textColor: Colors.white);
                                          Navigator.pop(context);
                                          setState(() {});
                                        }
                                      }, 
                                      icon: Icon(Icons.update_rounded),
                                      color: Colors.pink,
                                      highlightColor: Colors.pink,
                                    )
                                  ],
                                );
                              });
                            }, 
                          )
                        ])))));
  }

  _querySQLHelper() async {
    TUserProvider tUserProvider = TUserProvider();
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, "app4.db");
    await tUserProvider.open(path);
    TUser tUser = new TUser(email: user.email, password: user.password);
    await tUserProvider.update(tUser);
    tUserProvider.close();
  }
}
