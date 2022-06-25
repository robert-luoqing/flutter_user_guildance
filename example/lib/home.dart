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
  var tabs = ["Tab1", "Tab2", "Tab3"];

  @override
  void dispose() {
    userGuidanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserGuidance(
      controller: userGuidanceController,
      slotBuilder: (context, data) {
        if (data?.index == 1) {
          return BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          );
        }
        return null;
      },
      tipBuilder: (context, data) {
        if (data?.index == 1) {
          return Stack(children: [
            Positioned(
              left: (data?.position.dx ?? 0) - 120,
              top: (data?.position.dy ?? 0) - 30,
              child: Container(
                  color: Colors.red,
                  child: const Text(
                    "This is float button",
                  )),
            )
          ]);
        }
        return null;
      },
      child: DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            floatingActionButton: UserGuildanceAnchor(
                index: 1,
                child: FloatingActionButton(
                  onPressed: () {
                    userGuidanceController.show();
                  },
                )),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  TabBar(
                      tabs: tabs.map<Widget>((txt) {
                    var subIndex = tabs.indexOf(txt);
                    return Tab(
                        child: UserGuildanceAnchor(
                            index: 0,
                            subIndex: subIndex,
                            reportType: AnchorReportParentType.tab,
                            child: Text(
                              txt,
                              style: const TextStyle(color: Colors.black),
                            )));
                  }).toList()),
                  Expanded(
                      child: TabBarView(
                    children: tabs.map<Widget>((txt) => Container()).toList(),
                  ))
                ]),
              ),
            ),
          )),
    );
  }
}
