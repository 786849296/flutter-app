import 'package:sqflite/sqflite.dart';

final String tableName = "Tuser";
final String columnEmail = "email";
final String columnPassword = "password";

class TUser
{
  String? email;
  String? password;

  Map<String, dynamic> toMap()
  {
    var map = <String, dynamic> {
      columnEmail: email,
      columnPassword: password
    };
    return map;
  }

  TUser({this.email, this.password});
  TUser.fromMap(Map<String, dynamic> map) {
    email = map[columnEmail];
    password = map[columnPassword].toString();
  }
}

class TUserProvider
{
  Database? db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          create table $tableName (
            $columnEmail text primary key not null,
            $columnPassword text not null
          )
        ''');
      },
    );
  }
  Future<TUser> insert(TUser tUser) async {
    await db!.insert(tableName, tUser.toMap());
    return TUser();
  }
  Future<TUser> select(String email) async {
    List<Map<String, dynamic>> maps = await db!.query(
      tableName,
      columns: [columnPassword, columnEmail],
      where: '$columnEmail = ?',
      whereArgs: [email]
    );
    if(maps.length > 0)
      return TUser.fromMap(maps.first);
    return TUser();
  }
  Future<int> delete(String email) async {
    return await db!.delete(tableName, where: '$columnEmail = ?', whereArgs: [email]);
  }
  Future<int> update(TUser tUser) async {
    return await db!.update(
      tableName, 
      tUser.toMap(),
      where: '$columnEmail = ?',
      whereArgs: [tUser.email]
    );
  }
  Future close() async => db!.close();
}