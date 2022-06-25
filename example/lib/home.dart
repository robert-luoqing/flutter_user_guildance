import 'package:flutter/material.dart';
import 'package:flutter_user_guildance/flutter_user_guildance.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserGuidanceController userGuidanceController = UserGuidanceController();
  @override
  void dispose() {
    userGuidanceController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return UserGuidance(
      controller: userGuidanceController,
      slotBuilder: (context, data) {
        if (data?.index == 3) {
          return BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          );
        }
        return null;
      },
      tipBuilder: (context, data) {
        if (data?.index == 3) {
          return Stack(children: [
            Positioned(
              left: (data?.position.dx ?? 0) - 120,
              top: (data?.position.dy ?? 0) - 30,
              child: Container(
                  color: Colors.red,
                  child: const Text(
                    "Please follow the guildance",
                  )),
            )
          ]);
        }
        return null;
      },
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            floatingActionButton: UserGuildanceAnchor(
                index: 3,
                child: FloatingActionButton(
                  onPressed: () {
                    userGuidanceController.show();
                  },
                )),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  const TabBar(tabs: [
                    Tab(
                        child: UserGuildanceAnchor(
                            index: 1,
                            reportType: AnchorReportParentType.tab,
                            child: Text(
                              "Tab1",
                              style: TextStyle(color: Colors.black),
                            ))),
                    Tab(
                        child: UserGuildanceAnchor(
                            index: 2,
                            reportType: AnchorReportParentType.tab,
                            child: Text(
                              "Tab2",
                              style: TextStyle(color: Colors.black),
                            )))
                  ]),
                  Expanded(
                      child: TabBarView(
                    children: [Container(), Container()],
                  ))
                ]),
              ),
            ),
          )),
    );
  }
}
