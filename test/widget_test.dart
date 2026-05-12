import 'package:flutter_test/flutter_test.dart';
import 'package:delil/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DelilApp());
    expect(find.byType(MainShell), findsOneWidget);
  });
}
