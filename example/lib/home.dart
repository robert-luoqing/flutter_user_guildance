import 'package:flutter/material.dart';
import 'package:flutter_user_guildance/flutter_user_guildance.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserGuidanceController userGuidanceController = UserGuidanceController();
  var tabs = ["Tab1", "Tab2", "Tab3"];
  var buttonWidth = 100.0;

  @override
  void dispose() {
    userGuidanceController.dispose();
    super.dispose();
  }

  Widget renderBubble(String text) {
    return BubbleWidget(
      decoration: null,
      arrowPosition: 156,
      ignoreArrowHeight: false,
      direction: BubbleDirection.bottom,
      topLeftRadius: const Radius.circular(15.0),
      topRightRadius: const Radius.circular(15.0),
      bottomLeftRadius: const Radius.circular(15.0),
      bottomRightRadius: const Radius.circular(15.0),
      arrowHeight: 15,
      arrowWidth: 15,
      childBuilder: (context, direction) {
        return SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (() {}),
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Center(
                    child: Icon(Icons.cancel_outlined),
                  ),
                ),
              ),
              Container(
                  height: 80,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.blue],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                  child: Center(child: Text(text))),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return UserGuidance(
      controller: userGuidanceController,
      opacity: 0.5,
      slotBuilder: (context, data) {
        if (data?.step == 1) {
          return BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(data!.position.height / 2.0),
          );
        }
        return null;
      },
      tipBuilder: (context, data) {
        if (data != null) {
          return TipWidget(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 250.0),
                child: Text("${data.tag}")),
            data: data,
          );
        }

        return null;
      },
      child: DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            floatingActionButton: UserGuildanceAnchor(
                group: 1,
                step: 1,
                tag:
                    "This is tab Floating button. Click it to open new page. It should be friendly to the end user",
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
                    var subStep = tabs.indexOf(txt);
                    return Tab(
                        child: UserGuildanceAnchor(
                            step: 0,
                            subStep: subStep,
                            reportType: AnchorReportParentType.tab,
                            tag: "This is tab $txt",
                            child: Text(
                              txt,
                              style: const TextStyle(color: Colors.black),
                            )));
                  }).toList()),
                  Padding(
                    padding: EdgeInsets.only(top: buttonWidth),
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
                            await Future.delayed(const Duration(seconds: 5));
                            buttonWidth = 200;
                            setState(() {});
                            await Future.delayed(const Duration(seconds: 5));
                            buttonWidth = 100;
                            setState(() {});
                          },
                          child: SizedBox(
                              width: buttonWidth, child: const Text("Button"))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: renderBubble("Hello, It test"),
                  ),
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
