import 'package:flutter/material.dart';
import 'package:flutter_user_guildance/flutter_user_guildance.dart';

class TestNestGuidancePage extends StatefulWidget {
  const TestNestGuidancePage({
    Key? key,
  }) : super(key: key);

  @override
  State<TestNestGuidancePage> createState() => _TestNestGuidancePageState();
}

class _TestNestGuidancePageState extends State<TestNestGuidancePage> {
  UserGuidanceController controller1 = UserGuidanceController();
  UserGuidanceController controller2 = UserGuidanceController();

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserGuidance(
        controller: controller2,
        module: "module2",
        opacity: 0.5,
        child: UserGuidance(
          controller: controller1,
          opacity: 0.5,
          child: Scaffold(
              appBar: AppBar(
                title: const Text("Test Nest Guidance"),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: ElevatedButton(
                          onPressed: () async {
                            controller1.show();
                          },
                          child: const Text("Show controller1")),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          controller2.show();
                        },
                        child: const Text("Show controller2")),
                    ElevatedButton(
                        onPressed: () async {
                          controller1.show();
                          controller2.show();
                        },
                        child: const Text("Show controller1 and controller2")),
                    const UserGuildanceAnchor(
                      step: 1,
                      tag: "Group1",
                      child: Text("Group1"),
                    ),
                    const UserGuildanceAnchor(
                      module: "module2",
                      step: 1,
                      tag: "Group2",
                      child: Text("Group2"),
                    )
                  ]),
                ),
              )),
        ));
  }
}
