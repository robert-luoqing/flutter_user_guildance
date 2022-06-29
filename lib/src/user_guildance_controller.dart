import 'package:flutter/material.dart';

import 'user_guildance_anchor_inherit.dart';
import 'user_guildance_model.dart';

class UserGuidanceController extends ValueNotifier<UserGuildanceModel> {
  UserGuidanceController() : super(UserGuildanceModel(visible: false));

  BuildContext? _context;

  set currentPage(String? page) {
    if (value.currentPage != page) {
      value.currentPage = page;
      notifyListeners();
    }
  }

  void show({int group = 0, int index = 0, int subIndex = 0}) {
    var data = _getInitData(group, index, subIndex);
    value.visible = data != null;
    value.data = data;
    notifyListeners();
  }

  void next() {
    var data = _getNextData();
    value.visible = data != null;
    value.data = data;
    notifyListeners();
  }

  void hide() {
    value.visible = false;
    value.data = null;
    notifyListeners();
  }

  void attach(BuildContext context) {
    if (_context != context) {
      if (_context != null) {
        UserGuildanceAnchorInherit.of(_context!)
            ?.removePositionListener(positionListener);
      }
      _context = context;
      if (_context != null) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          UserGuildanceAnchorInherit.of(_context!)
              ?.addPositionListener(positionListener);
        });
      }
    }
  }

  void detach() {
    if (_context != null) {
      UserGuildanceAnchorInherit.of(_context!)
          ?.removePositionListener(positionListener);
      _context = null;
    }
  }

  void positionListener(AnchorData data, bool isNew) {
    var curAnchorData = value.data;
    if (curAnchorData != null) {
      if (curAnchorData.group == data.group) {
        if (curAnchorData.step == data.step &&
            curAnchorData.subStep == data.subStep) {
          value.data = data;
        }

        WidgetsBinding.instance!.addPostFrameCallback(
          (timeStamp) {
            notifyListeners();
          },
        );
      }
    }
  }

  /// return: 0: equal, 1: above, -1: less
  int compair(int step, int subStep, int compairStep, int compairSubStep) {
    if (step > compairStep) {
      return 1;
    } else if (step == compairStep) {
      if (subStep > compairSubStep) {
        return 1;
      } else if (subStep == compairSubStep) {
        return 0;
      }
    }

    return -1;
  }

  AnchorData? _getInitData(int group, int step, int subStep) {
    AnchorData? minItem;
    if (_context != null) {
      var data = UserGuildanceAnchorInherit.of(_context!)?.anchorDatas;
      if (data != null) {
        for (var item in data) {
          if (item.group == group) {
            var compairResult =
                compair(item.step, item.subStep ?? 0, step, subStep);
            if (compairResult != -1) {
              if (minItem == null) {
                minItem = item;
              } else {
                compairResult = compair(item.step, item.subStep ?? 0,
                    minItem.step, minItem.subStep ?? 0);
                if (compairResult != 1) {
                  minItem = item;
                }
              }
            }
          }
        }
      }
    }

    return minItem;
  }

  AnchorData? _getNextData() {
    var curData = value.data;
    if (curData == null) {
      throw "Not start";
    } else {
      AnchorData? minItem;
      if (_context != null) {
        var data = UserGuildanceAnchorInherit.of(_context!)?.anchorDatas;
        if (data != null) {
          for (var item in data) {
            if (curData.group == item.group) {
              var compairResult = compair(item.step, item.subStep ?? 0,
                  curData.step, curData.subStep ?? 0);
              if (compairResult == 1) {
                if (minItem == null) {
                  minItem = item;
                } else {
                  compairResult = compair(item.step, item.subStep ?? 0,
                      minItem.step, minItem.subStep ?? 0);
                  if (compairResult == -1) {
                    minItem = item;
                  }
                }
              }
            }
          }
        }
      }

      return minItem;
    }
  }
}
