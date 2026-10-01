import 'package:flutter_test/flutter_test.dart';

import 'package:to_do_app/main.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const TasksApp());

    expect(find.text('Tasks'), findsWidgets);
  });
}
