import 'package:auto_pooling_driver/app.dart';
import 'package:auto_pooling_driver/core/services/injection_container.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(configureDependencies);

  testWidgets('renders dashboard scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(const AutoPoolingDriverApp());
    await tester.pumpAndSettle();

    expect(find.text('Auto Pooling'), findsOneWidget);
    expect(find.text('Refresh summary'), findsOneWidget);
  });
}
