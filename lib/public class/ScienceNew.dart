class ScienceNew
{
  int? code;
  String? msg;
  String ctime;
  String title;
  String description;
  String? picurl;
  String url;

  ScienceNew({this.code, required this.ctime, required this.description, this.msg, this.picurl, required this.title, required this.url});
  factory ScienceNew.fromJson(Map<String, dynamic> json) {
    return ScienceNew(
      code: json["code"],
      msg: json["msg"],
      ctime: json["ctime"],
      title: json["title"],
      description: json["description"],
      picurl: json["picUrl"],
      url: json["url"],
    );
  }
}