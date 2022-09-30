import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_user_guildance/flutter_user_guildance.dart';

void main() {
  testWidgets('test example', (WidgetTester tester) async {
    var testButton = find.text("Button");

    UserGuidanceController userGuidanceController = UserGuidanceController();
    var testWidget = MaterialApp(
        home: UserGuidance(
      controller: userGuidanceController,
      opacity: 0.5,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: UserGuildanceAnchor(
            step: 1,
            tag: "Start press the button",
            child: ElevatedButton(
                key: const ValueKey("testButton"),
                onPressed: () {
                  userGuidanceController.show();
                },
                child: const Text("Button")),
          ),
        ),
      ),
    ));
    await tester.pumpWidget(testWidget);
    await tester.tap(testButton);
    await tester.pump();

    var matchWidget = find.text("Start press the button");
    expect(matchWidget, findsOneWidget);
  });
}
