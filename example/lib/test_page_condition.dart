import 'package:flutter/material.dart';
import 'package:flutter_user_guildance/flutter_user_guildance.dart';

class TestPageConditionPage extends StatefulWidget {
  const TestPageConditionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TestPageConditionPage> createState() => _TestPageConditionPageState();
}

class _TestPageConditionPageState extends State<TestPageConditionPage> {
  UserGuidanceController userGuidanceController = UserGuidanceController();

  @override
  void dispose() {
    userGuidanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserGuidance(
      controller: userGuidanceController,
      anchorPageConditions: const {1: "Page2"},
      opacity: 0.5,
      child: Scaffold(
          floatingActionButton: UserGuildanceAnchor(
              group: 1,
              step: 1,
              tag:
                  "This is tab Floating button. Click it to open new page. It should be friendly to the end user",
              child: FloatingActionButton(
                onPressed: () {},
              )),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: UserGuildanceAnchor(
                    group: 1,
                    step: 2,
                    tag: "Start press the button",
                    adjustRect: (rect) {
                      return Rect.fromLTWH(rect.left, rect.top + 5.0,
                          rect.width, rect.height - 10.0);
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
                      for (var i = 0; i < 4; i++) {
                        userGuidanceController.currentPage = "Page1";
                        await Future.delayed(const Duration(seconds: 2));
                        userGuidanceController.currentPage = "Page4";
                        await Future.delayed(const Duration(seconds: 2));
                        userGuidanceController.currentPage = "Page3";
                      }
                    },
                    child: const Text("Change belong page")),
              ]),
            ),
          )),
    );
  }
}
