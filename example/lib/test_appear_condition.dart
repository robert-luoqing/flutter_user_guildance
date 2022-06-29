import 'package:flutter/material.dart';
import 'package:flutter_user_guildance/flutter_user_guildance.dart';

class TestAppearConditionPage extends StatefulWidget {
  const TestAppearConditionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TestAppearConditionPage> createState() =>
      _TestAppearConditionPageState();
}

class _TestAppearConditionPageState extends State<TestAppearConditionPage> {
  UserGuidanceController userGuidanceController = UserGuidanceController();

  bool showStep3 = false;

  @override
  void dispose() {
    userGuidanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserGuidance(
      controller: userGuidanceController,
      anchorAppearConditions: {
        1: [UserGuidanceAppearCondition(step: 3)]
      },
      opacity: 0.5,
      child: Scaffold(
          body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: UserGuildanceAnchor(
                group: 1,
                step: 2,
                tag: "Start press the button",
                adjustRect: (rect) {
                  return Rect.fromLTWH(rect.left, rect.top + 5.0, rect.width,
                      rect.height - 10.0);
                },
                child: ElevatedButton(
                    onPressed: () async {
                      userGuidanceController.show(group: 1);
                    },
                    child: const Text("Button")),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  showStep3 = true;
                  setState(() {});
                },
                child: const Text("Show Step 3")),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: showStep3
                  ? UserGuildanceAnchor(
                      group: 1,
                      step: 3,
                      tag: "Step 3 button",
                      child: ElevatedButton(
                          onPressed: () async {},
                          child: const Text("Step 3 button")),
                    )
                  : Container(),
            ),
          ]),
        ),
      )),
    );
  }
}
