import 'package:app4/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main()
{
  testWidgets("选择同学widget测试", (WidgetTester tester) async {
    await tester.pumpWidget(SelectStudent());
    final finder5055 = find.text("5120185055赵付邦");
    final finder5068 = find.text("5120185068徐世庆");

    expect(finder5055, findsOneWidget);
    expect(finder5068, findsOneWidget);
  });
}