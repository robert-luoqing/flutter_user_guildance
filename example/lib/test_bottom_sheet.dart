import 'package:flutter/material.dart';
import 'package:flutter_user_guildance/flutter_user_guildance.dart';

class TestBottomSheetPage extends StatefulWidget {
  const TestBottomSheetPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TestBottomSheetPage> createState() => _TestBottomSheetPageState();
}

class _TestBottomSheetPageState extends State<TestBottomSheetPage> {
  UserGuidanceController userGuidanceController = UserGuidanceController();

  @override
  void dispose() {
    userGuidanceController.dispose();
    super.dispose();
  }

  Widget buildBottomSheetUI() {
    return SafeArea(
        child: UserGuidance(
            controller: userGuidanceController,
            showMaskWhenMissCondition: true,
            opacity: 0.5,
            child: Container(
                color: Colors.red,
                child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserGuildanceAnchor(
                              step: 0,
                              child: Container(
                                color: Colors.pink,
                                child: Text("Step 1"),
                              )),
                          UserGuildanceAnchor(
                              step: 1,
                              child: Container(
                                color: Colors.pink,
                                child: Text("Step 2"),
                              )),
                          ElevatedButton(
                              onPressed: () async {
                                userGuidanceController.show();
                              },
                              child: const Text("Show Guidance")),
                        ])))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Test Bottom Sheet"),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: ElevatedButton(
                    onPressed: () async {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return buildBottomSheetUI();
                          });
                    },
                    child: const Text("Show Bottom sheet")),
              ),
            ]),
          ),
        ));
  }
}
