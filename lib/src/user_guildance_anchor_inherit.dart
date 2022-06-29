import 'package:flutter/material.dart';

class AnchorData {
  AnchorData(
      {required this.group,
      required this.step,
      required this.position,
      this.subStep,
      this.tag,
      this.inScrollZone});
  int group;
  int step;
  int? subStep;
  Rect position;
  dynamic tag;
  bool? inScrollZone;
}

typedef PositoinChangeHandler = void Function(AnchorData, bool);

class UserGuildanceAnchorInherit extends InheritedWidget {
  const UserGuildanceAnchorInherit(
      {Key? key,
      required Widget child,
      required this.anchorDatas,
      required this.positionHandlers})
      : super(key: key, child: child);

  final List<AnchorData> anchorDatas;
  final List<PositoinChangeHandler> positionHandlers;

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

  void addPositionListener(PositoinChangeHandler callback) {
    if (!positionHandlers.contains(callback)) {
      positionHandlers.add(callback);
    }
  }

  void removePositionListener(PositoinChangeHandler callback) {
    if (positionHandlers.contains(callback)) {
      positionHandlers.remove(callback);
    }
  }

  void _notifyPositoinChanged(AnchorData data, bool isInsert) {
    for (var handler in positionHandlers) {
      handler(data, isInsert);
    }
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
