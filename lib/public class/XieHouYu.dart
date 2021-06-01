class XieHouYu
{
  int code;
  String msg;
  String last;
  String next;

  XieHouYu({required this.code, required this.msg, required this.last, required this.next});
  factory XieHouYu.fromJson(Map<String, dynamic> json) {
    return XieHouYu(
      code: json["code"],
      msg: json["msg"],
      last: json['quest'],
      next: json['result']
    );
  }
}