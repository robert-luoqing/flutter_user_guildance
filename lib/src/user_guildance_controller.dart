import 'package:flutter/material.dart';

import 'user_guildance_anchor_inherit.dart';
import 'user_guildance_model.dart';

class UserGuidanceController extends ValueNotifier<UserGuildanceModel> {
  UserGuidanceController() : super(const UserGuildanceModel.initial());

  BuildContext? _context;

  void show({int group = 0, int index = 0, int subIndex = 0}) {
    var data = _getInitData(group, index, subIndex);
    value = UserGuildanceModel.custom(visible: data != null, anchorData: data);
  }

  void next() {
    var data = _getNextData();
    value = UserGuildanceModel.custom(visible: data != null, anchorData: data);
  }

  void hide() {
    value = const UserGuildanceModel.custom(visible: false, anchorData: null);
  }

  void attach(BuildContext context) {
    _context = context;
  }

  void detach() {
    _context = null;
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
      var data = UserGuildanceAnchorInherit.of(_context!)?.data;
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
        var data = UserGuildanceAnchorInherit.of(_context!)?.data;
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
