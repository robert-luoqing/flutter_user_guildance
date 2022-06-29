import 'package:flutter/material.dart';
import 'package:flutter_user_guildance/flutter_user_guildance.dart';

class TestPositionConditionPage extends StatefulWidget {
  const TestPositionConditionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TestPositionConditionPage> createState() =>
      _TestPositionConditionPageState();
}

class _TestPositionConditionPageState extends State<TestPositionConditionPage> {
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
      anchorPositionConditions: {
        0: [
          UserGuidancePositionCondition(
              step: 2, minY: -1, maxY: -1, minX: -1, maxX: -1)
        ]
      },
      anchorAppearConditions: {
        0: [UserGuidanceAppearCondition(step: 2)]
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
                step: 1,
                tag: "Start press the button",
                child: ElevatedButton(
                    onPressed: () async {
                      userGuidanceController.show(group: 0);
                    },
                    child: const Text("Button")),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: ((context, index) {
                Widget item =
                    SizedBox(height: 40, child: Text("Item - $index"));
                if (index == 33) {
                  item = UserGuildanceAnchor(
                      needMonitorScroll: true,
                      step: 2,
                      tag: "Item - $index",
                      child: item);
                }
                return item;
              }),
              itemCount: 1000,
            ))
          ]),
        ),
      )),
    );
  }
}
