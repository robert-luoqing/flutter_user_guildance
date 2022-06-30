## Flutter User Guildance
Provide the user guildance widget to make developers easy to make new user tips.

## Screen

|  |  |
| :-----:| :----: |
| ![](screen/sample1.png) | ![](screen/sample2.png) |

## UserGuildanceAnchor
The widget is used to mark what widget need highlight. Using the widget wrap the item which you want to highlight

| Property | Usage |
| :-----| :---- |
| group | You can specify which group will be show in the user guildance. |
| step | The step which show in group. |
| subStep | If the step is same, subStep will be determine the show order. |
| tag | The tag will pass to tipBuilder and slotBuilder. If the end user is not provide tipBuilder, the tag will be used as tip string. |
| reportType | null: Just highlight itself, tab: It will find parent tab node to highlight it. |
| adjustRect | If the hight rect is not accurate or not you want. The method will allow you to adjust the highlight rect. |
| needMonitorScroll | If the item is in list view or scroll view, We need set the property to true to report the location when scrolling. It also report does the item is in list viewport (Visible area) |

## UserGuildance
The wiget is used to show highlight items. It make sure the widget show in full screen.  
Notice: If the conditions have been set, controller.show() may not work util the condition meet. The advantage is if the item is in list view and invisible, when the item is visible, the user guildance will automatically show up.


| Property | Usage |
| :-----| :---- |
| controller | The controller is used to show, hide and move next step. |
| tipBuilder | Provide custom tip widget. |
| slotBuilder | Provide custom slot effect. |
| opacity | The mask's opacity |
| duration | The animiation time in two step. |
| customAnchors | Add custom anchors which not wrap widget. |
| moveNextOnTap | true: Move next when tap user guildance area. false: It need the user to mainipulate controller to move next. |
| anchorAppearConditions | All anchor has show in UI. For example: anchorAppearConditions: { 1: [UserGuidanceAppearCondition(step: 3)] }. 1: is group, If you have invoke controller.show(group: 1), But step 3 in anchor is not report its location, The guildance will not show up util the anchor(step 3) report its location  |
| anchorPositionConditions | All anchor location has meet the conditions. See: anchorPositionConditions |
| anchorPageConditions | The group should meet page setting. The case is, if the anchor have report location but in invisble tab. In the case, We just simplify it. You can simple set the page condition to control it. See: anchorPositionConditions |
| showMaskWhenMissCondition | If the user invoked controller.show, But condition is not meet. true: It will show progress, false: show nothing |

### anchorPositionConditions
```
/// 0: is group. If minY, maxY, minX and maxX both is -1, It mean the condition is that the anchor visible in listview or scrollview.
/// Otherwise, the condition shoud meeting the area.
anchorPositionConditions: {
    0: [
      UserGuidancePositionCondition(
          step: 2, minY: -1, maxY: -1, minX: -1, maxX: -1)
    ]
  },
```

### anchorPageConditions
```
anchorPageConditions: const {1: "Page2"},

// In controller
controller.currentPage = "Page2";
```

## UserGuidanceController
The controller is used to show, hide and move next step.

| Property | Usage |
| :-----| :---- |
| show | Begin show the user guildance. You can specify group to determine which group guildance you want to show up |
| next | Move next step. You must invoke show before |
| hide | End the user guildance |
| opacity | The mask's opacity |
| duration | The animiation time in two step. |

## TipWidget
The widget is default wighet which is used in UserGuildance. You can customize it to implement the difference style. It just wrap BubbleWidget.

| Property | Usage |
| :-----| :---- |
| data | it is AnchorData. which provide in tipBuilder. It was used to calculate the arrow position. If you want specify your arrow position. You can use BubbleWidget |
| arrowWidth | Arrow width |
| arrowHeight | Arrow height |
| four radius | The tip border radius |
| decoration | The tip widget background decoration. |
| ignoreArrowHeight | The content will extend arrow area if the value is false. It make the user easy to extend the fill color |
| tipWidgetAlign | It will make sure the tip only show with left/right or top/bottom |

## BubbleWidget
The widget provide basic tip functionality

| Property | Usage |
| :-----| :---- |
| direction | Which side the arrow should be show in |
| arrowWidth | Arrow width |
| arrowHeight | Arrow height |
| arrowPosition | Arrow position based on arrowPositionBased |
| arrowPositionBased | How calculate the arrowPosition based on. For example: start - If direction is top and bottom, The arrowPosition should be based on the left. |
| four radius | The tip border radius |
| decoration | The tip widget background decoration. |
| ignoreArrowHeight | The content will extend arrow area if the value is false. It make the user easy to extend the fill color |

## Simple Example
```dart
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
```

## Complex Example
```dart
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
```
