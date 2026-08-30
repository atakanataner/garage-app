import 'package:flutter_test/flutter_test.dart';
import 'package:garage_app/main.dart';

void main() {
  testWidgets('Garage app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GarageApp());

    // Verify that the title 'GARAGE' exists in the UI
    expect(find.text('GARAGE'), findsWidgets);
  });
}
