import 'package:sqflite/sqflite.dart';

final String tableName = "TNews";
final String columnId = "id";
final String columnCtime = "ctime";
final String columnTitle = "title";
final String columnDescription = "description";
final String columnPicUrl = "picUrl";
final String columnUrl = "url";

class TNews
{
  int? id;
  String? ctime;
  String? title;
  String? description;
  String? picUrl;
  String? url;

  Map<String, dynamic> toMap()
  {
    var map = <String, dynamic> {
      columnId: id,
      columnCtime: ctime,
      columnTitle: title,
      columnDescription: description,
      columnPicUrl: picUrl,
      columnUrl: url,
    };
    return map;
  }

  TNews({this.id, this.ctime, this.title, this.description, this.picUrl, this.url});
  TNews.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    ctime = map[columnCtime];
    title = map[columnTitle];
    description = map[columnDescription];
    picUrl = map[columnPicUrl];
    url = map[columnUrl];
  }
}

class TNewsProvider
{
  Database? db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          create table $tableName (
            $columnId integer primary key autoincrement,
            $columnCtime text not null,
            $columnTitle text not null,
            $columnDescription text not null,
            $columnPicUrl text not null,
            $columnUrl text not null
          )
        ''');
      },
    );
  }
  Future<TNews> insert(TNews tNews) async {
    tNews.id = await db!.insert(tableName, tNews.toMap());
    return tNews;
  }
  Future<TNews> select(int id) async {
    List<Map<String, dynamic>> maps = await db!.query(
      tableName,
      columns: [columnId, columnCtime, columnTitle, columnDescription, columnPicUrl, columnUrl],
      where: '$columnId = ?',
      whereArgs: [id]
    );
    if(maps.length > 0)
      return TNews.fromMap(maps.first);
    return TNews();
  }
  Future<int> delete(int id) async {
    return await db!.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
  Future<int> update(TNews tNews) async {
    return await db!.update(
      tableName, 
      tNews.toMap(),
      where: '$columnId = ?',
      whereArgs: [tNews.id]
    );
  }
  Future close() async => db!.close();
}