import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_user_guildance_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('test example', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final actionButton = find.byType(FloatingActionButton);
      expect(actionButton, findsOneWidget);
      await tester.tap(actionButton);
      await tester.pumpAndSettle();

      // GestureDetector
      const tip1 = "This is tab Tab1";
      final popupTip = find.widgetWithText(GestureDetector, tip1);
      expect(find.text(tip1), findsOneWidget);
      await tester.tap(popupTip);
      await tester.pumpAndSettle();
      const tip2 = "This is tab Tab2";
      expect(find.text(tip2), findsOneWidget);
      // await Future.delayed(const Duration(seconds: 5));
    });
  });
}
