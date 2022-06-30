import 'package:flutter/material.dart';

enum AnchorDataType { node, custom }

class AnchorData {
  AnchorData(
      {required this.group,
      required this.step,
      required this.position,
      this.subStep,
      this.tag,
      this.inScrollZone,
      this.type = AnchorDataType.custom});
  int group;
  int step;
  int? subStep;
  Rect position;
  dynamic tag;
  bool? inScrollZone;
  AnchorDataType type;
}

typedef PositoinChangeHandler = void Function(AnchorData, bool);

class UserGuildanceAnchorInherit extends InheritedWidget {
  const UserGuildanceAnchorInherit(
      {Key? key,
      required Widget child,
      required this.anchorDatas,
      required this.onPositionChanged})
      : super(key: key, child: child);

  final List<AnchorData> anchorDatas;
  final PositoinChangeHandler onPositionChanged;

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static UserGuildanceAnchorInherit? of(BuildContext context) {
    var instance = context
        .dependOnInheritedWidgetOfExactType<UserGuildanceAnchorInherit>();
    return instance;
  }

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget重新build
  @override
  bool updateShouldNotify(UserGuildanceAnchorInherit oldWidget) {
    return false;
  }

  void _notifyPositoinChanged(AnchorData data, bool isInsert) {
    onPositionChanged(data, isInsert);
  }

  void report(int group, int step, int? subStep, Rect position, dynamic tag,
      bool? inScrollZone) {
    var matched = false;
    for (var item in anchorDatas) {
      if (item.step == step && item.subStep == subStep && item.group == group) {
        if (item.position.top != position.top ||
            item.position.left != position.left ||
            item.position.width != position.width ||
            item.position.height != position.height) {
          item.position = position;
          item.inScrollZone = inScrollZone;
          _notifyPositoinChanged(item, false);
        }
        matched = true;
        break;
      }
    }

    if (!matched) {
      var item = AnchorData(
          group: group,
          step: step,
          subStep: subStep,
          position: position,
          tag: tag,
          inScrollZone: inScrollZone);
      anchorDatas.add(item);
      _notifyPositoinChanged(item, true);
    }
  }

  void remove(int step, int? subStep) {
    var length = anchorDatas.length;
    for (var i = length - 1; i >= 0; i--) {
      var item = anchorDatas[i];
      if (item.step == step && item.subStep == subStep) {
        anchorDatas.removeAt(i);
        break;
      }
    }
  }
}
