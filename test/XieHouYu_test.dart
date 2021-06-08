import 'package:app4/public%20class/XieHouYu.dart';
import 'package:flutter_test/flutter_test.dart';

void main()
{
  test("测试歇后语类", () {
    final xiehouyu = new XieHouYu(code: 1, msg: "msg", last: "last", next: "next");
    expect(xiehouyu.code, 1);
    expect(xiehouyu.msg, "msg");
    expect(xiehouyu.last, "last");
    expect(xiehouyu.next, "next");
  });

  test("测试歇后语类", () {
    Map<String, dynamic> json = {"code" : 1, "msg" : "msg", "quest" : "last", "result" : "next"};
    var xiehouyu = XieHouYu.fromJson(json);
    expect(xiehouyu.code, 1);
    expect(xiehouyu.msg, "msg");
    expect(xiehouyu.last, "last");
    expect(xiehouyu.next, "next");
  });
}