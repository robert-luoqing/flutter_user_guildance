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
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      userGuidanceController.show();
    });

    super.initState();
  }

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
      customAnchors: [
        UserGuildanceCustomAnchor(
            group: 0,
            step: 4,
            position: const Rect.fromLTWH(100, 100, 0, 0),
            tag: "This is custom tag1"),
        UserGuildanceCustomAnchor(
            group: 0,
            step: 5,
            position: const Rect.fromLTWH(100, 100, 0, 0),
            tag: "This is custom tag2")
      ],
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
                step: 3,
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
