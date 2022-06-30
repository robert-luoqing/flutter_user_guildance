import 'package:flutter/material.dart';
import 'package:flutter_user_guildance/flutter_user_guildance.dart';

class TestComplexConditionPage extends StatefulWidget {
  const TestComplexConditionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TestComplexConditionPage> createState() =>
      _TestComplexConditionPageState();
}

class _TestComplexConditionPageState extends State<TestComplexConditionPage> {
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
      anchorPageConditions: const {1: "Page1", 2: "Page2"},
      showMaskWhenMissCondition: true,
      anchorAppearConditions: {
        1: [UserGuidanceAppearCondition(step: 2)]
      },
      opacity: 0.5,
      child: Scaffold(
          body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: ElevatedButton(
                  onPressed: () async {
                    userGuidanceController.show(group: 1);
                    userGuidanceController.show(group: 2);
                  },
                  child: const Text("Show all group guidance")),
            ),
            ElevatedButton(
                onPressed: () async {
                  userGuidanceController.currentPage = "Page1";
                  setState(() {});
                  await Future.delayed(const Duration(seconds: 4));
                  userGuidanceController.currentPage = "Page2";
                  setState(() {});
                  await Future.delayed(const Duration(seconds: 4));
                  userGuidanceController.currentPage = "Page3";
                  setState(() {});
                },
                child: const Text("Change current page")),
            const UserGuildanceAnchor(
              group: 1,
              step: 1,
              tag: "Group1",
              child: Text("Group1"),
            ),
            const UserGuildanceAnchor(
              group: 2,
              step: 1,
              tag: "Group2",
              child: Text("Group2"),
            ),
            Text("Current group: ${userGuidanceController.currentPage}")
          ]),
        ),
      )),
    );
  }
}
