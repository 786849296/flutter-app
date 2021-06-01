import 'package:app4/5120185055/Navigation.dart';
import 'package:app4/5120185055/submit.dart';
import 'package:app4/databass/TableUser.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

bool password_save = false;

class Login5055 extends StatelessWidget
{
  TextEditingController email_controller = new TextEditingController();
  TextEditingController password_controller = new TextEditingController();

  Widget build(BuildContext context) {
    Future<String> email = get_email();
    Future<bool> isSave = get_isSave();
    Future<String> password = get_password();
    email.then((value) => user.email = value);
    password.then((value) => user.password = value);
    isSave.then((value) {
      password_save = value;
      if(password_save)
      {
        email_controller.text = user.email;
        password_controller.text = user.password;
      }
    });

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
                  Passwordinput(hint: '密码', textEditingController: password_controller),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PasswordSave(),
                      Text("  保存密码")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(100, 30)),
                          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          overlayColor: MaterialStateProperty.all(Colors.blueAccent[100]),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
                        ),
                        onPressed: ((){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Submit()));
                        }), 
                        child: Text('注册')
                        ),
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(100, 30)),
                          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          overlayColor: MaterialStateProperty.all(Colors.blueAccent[100]),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
                        ),
                        onPressed: ((){
                          _querySQLHelper().then((id){
                            if(email_controller.text == user.email && password_controller.text == user.password)
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Navigation()));
                              save();
                            }
                            else
                              showDialog(context: context, builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text('登录信息错误'),
                                );
                              }
                            );
                          });
                        }), 
                        child: Text('登录')
                        ),
                    ],
                  )
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
    prefs.setBool("isSave", password_save);
    prefs.setString("email", user.email);
    prefs.setString("password", user.password);
  }
  Future<bool> get_isSave() async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool is_save = prefs.getBool("isSave")!;
    return is_save;
  }
  Future<String> get_email() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email")!;
    return email;
  }
  Future<String> get_password() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? password = prefs.getString("password");
    if (password == null)
      return "";
    return password;
  }

  _querySQLHelper() async {
    TUserProvider tUserProvider = TUserProvider();
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, "app4.db");
    await tUserProvider.open(path);
    TUser tUser = await tUserProvider.select(email_controller.text);
    user.email = tUser.email!;
    user.password = tUser.password!;
    tUserProvider.close();
  }
}

class EmailInput extends StatefulWidget {
  TextEditingController textEditingController;
  EmailInput({required this.textEditingController});
  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        icon: Icon(
                    Icons.email_outlined,
                    color: Colors.blueAccent[100],
                    size: 24,
          ),
        labelText: '账户',
      ),
    );
  }
}

class Passwordinput extends StatefulWidget {
  String hint;
  TextEditingController textEditingController;
  Passwordinput({required this.hint, required this.textEditingController});
  @override
  _PasswordinputState createState() => _PasswordinputState();
}

class _PasswordinputState extends State<Passwordinput> {
  var Password_visible = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: Password_visible,
      maxLines: 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        icon: Icon(
                    Icons.lock,
                    color: Colors.blueAccent[100],
                    size: 24,
          ),
        suffixIcon: IconButton(
          icon: Icon(
            Password_visible ? Icons.visibility : Icons.visibility_off,
            ),
          onPressed: (){
            setState(() {
              Password_visible = !Password_visible;
              });
            },
          ),
        labelText: widget.hint,
        ),
    );
  }
}

class PasswordSave extends StatefulWidget {
  @override
  _PasswordSaveState createState() => _PasswordSaveState();
}

class _PasswordSaveState extends State<PasswordSave> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: password_save,
      onChanged: (value){
        setState(() {
          password_save = value;
        });
      },
    );
  }
}