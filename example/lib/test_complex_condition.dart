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
          appBar: AppBar(
            title: const Text("Test Complex Condition"),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: ElevatedButton(
                      onPressed: () async {
                        userGuidanceController.show(group: 1);
                      },
                      child: const Text("Show  group 1 guidance")),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: ElevatedButton(
                      onPressed: () async {
                        userGuidanceController.show(group: 2);
                      },
                      child: const Text("Show  group 2 guidance")),
                ),
                ElevatedButton(
                    onPressed: () async {
                      userGuidanceController.currentPage = "Page1";
                      setState(() {});
                    },
                    child: const Text("Change current page1 (Group 1)")),
                ElevatedButton(
                    onPressed: () async {
                      userGuidanceController.currentPage = "Page2";
                      setState(() {});
                    },
                    child: const Text("Change current page2 (Group 2)")),
                ElevatedButton(
                    onPressed: () async {
                      userGuidanceController.currentPage = "Page3";
                      setState(() {});
                    },
                    child: const Text("Change current page3 (No Group)")),
                const UserGuildanceAnchor(
                  group: 1,
                  step: 1,
                  tag: "Group1",
                  child: Text("Group1"),
                ),
                const UserGuildanceAnchor(
                  group: 1,
                  step: 2,
                  tag: "Group1",
                  child: Text("Group1 step 2"),
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
