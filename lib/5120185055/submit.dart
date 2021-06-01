import 'package:app4/databass/TableUser.dart';
import 'package:app4/public%20class/User.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

User user = new User();

class Submit extends StatelessWidget 
{
  TextEditingController email_controller = new TextEditingController();
  TextEditingController password_controller = new TextEditingController();
  TextEditingController password_again_controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 0.1 * 0.8 * MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent, width: 3)
                    ),
                    child: Icon(
                      Icons.accessible_forward_outlined,
                      color: Colors.blue,
                      size: 48,
                    ),
                  ),
                  EmailInput(textEditingController: email_controller,),
                  Passwordinput(hint: "密码", textEditingController: password_controller,),
                  Passwordinput(hint: "再次输入密码", textEditingController: password_again_controller,),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(100, 30)),
                      backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      overlayColor: MaterialStateProperty.all(Colors.blueAccent[100]),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
                      ),
                    onPressed: ((){
                      if(password_controller.text.isEmpty || email_controller.text.isEmpty)
                        showDialog(context: context, builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text('请将信息输入完整'),
                            );
                          }
                        );
                      else if(password_controller.text == password_again_controller.text)
                      {
                        user.email = email_controller.text;
                        user.password = password_controller.text;
                        save();
                        _querySQLHelper();
                        Fluttertoast.showToast(msg: "注册成功", backgroundColor: Colors.blue, textColor: Colors.white);
                        Navigator.pop(context, user);
                      }
                      else
                        showDialog(context: context, builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text('密码不一致'),
                            );
                          }
                        );
                    }), 
                    child: Text('注册')
                  ),
                ],
              ),
            )
          )
        ),
      )
    );
  }

  save() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", user.email);
    prefs.setString("password", user.password);
  }

  _querySQLHelper() async {
    TUserProvider tUserProvider = TUserProvider();
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, "app4.db");
    await tUserProvider.open(path);
    TUser tUser = new TUser(email: user.email, password: user.password);
    await tUserProvider.insert(tUser);
    tUserProvider.close();
  }
}

