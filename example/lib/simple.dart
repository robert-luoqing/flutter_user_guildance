import 'package:flutter/material.dart';
import 'package:flutter_user_guildance/flutter_user_guildance.dart';

class SimplePage extends StatefulWidget {
  const SimplePage({
    Key? key,
  }) : super(key: key);

  @override
  State<SimplePage> createState() => _SimplePageState();
}

class _SimplePageState extends State<SimplePage> {
  UserGuidanceController userGuidanceController = UserGuidanceController();

  @override
  Widget build(BuildContext context) {
    return UserGuidance(
      controller: userGuidanceController,
      opacity: 0.5,
      child: Scaffold(
        floatingActionButton: UserGuildanceAnchor(
            step: 1,
            tag: "This is tab Floating button.",
            child: FloatingActionButton(
              onPressed: () {
                userGuidanceController.show();
              },
            )),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: UserGuildanceAnchor(
              step: 2,
              tag: "Start press the button",
              child:
                  ElevatedButton(onPressed: () {}, child: const Text("Button")),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    userGuidanceController.dispose();
    super.dispose();
  }
}
