import 'package:flutter/material.dart';

class AnchorData {
  AnchorData(
      {required this.index,
      required this.position,
      required this.size,
      this.subIndex,
      this.tag});
  int index;
  int? subIndex;
  Offset position;
  Size size;
  dynamic tag;
}

class UserGuildanceAnchorInherit extends InheritedWidget {
  UserGuildanceAnchorInherit({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  final List<AnchorData> data = []; //需要在子树中共享的数据，保存点击次数

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static UserGuildanceAnchorInherit? of(BuildContext context) {
    var instance = context.dependOnInheritedWidgetOfExactType<UserGuildanceAnchorInherit>();
    return instance;
  }

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget重新build
  @override
  bool updateShouldNotify(UserGuildanceAnchorInherit oldWidget) {
    return false;
  }

  void report(
      int index, int? subIndex, Offset position, Size size, dynamic tag) {
    var matched = false;
    for (var item in data) {
      if (item.index == index && item.subIndex == subIndex) {
        if (item.position.dx != position.dx &&
            item.position.dy != position.dy &&
            item.size.width != size.width &&
            item.size.height != size.height) {
          item.position = position;
          item.size = size;
        }
        matched = true;
        break;
      }
    }

    if (!matched) {
      data.add(AnchorData(
          index: index,
          subIndex: subIndex,
          position: position,
          size: size,
          tag: tag));
    }
  }

  void remove(int index, int? subIndex) {
    var length = data.length;
    for (var i = length - 1; i >= 0; i--) {
      var item = data[i];
      if (item.index == index && item.subIndex == subIndex) {
        data.removeAt(i);
        break;
      }
    }
  }
}
