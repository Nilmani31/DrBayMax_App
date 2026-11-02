import 'package:flutter_test/flutter_test.dart';

import 'package:dr_baymax/main.dart';

void main() {
  testWidgets('DrBayMax login flow opens the home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('DrBayMax'), findsOneWidget);
    expect(find.text('Meet Your DrBayMax'), findsOneWidget);

    await tester.tap(find.text('Meet Your DrBayMax'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.textContaining("Baymax is ready!"), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
