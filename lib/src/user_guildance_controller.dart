import 'package:flutter/material.dart';

import 'user_guildance_anchor_inherit.dart';
import 'user_guildance_model.dart';

class UserGuidanceController extends ValueNotifier<UserGuildanceModel> {
  UserGuidanceController() : super(const UserGuildanceModel.initial());

  BuildContext? _context;

  void show({int index = 0, int subIndex = 0}) {
    var data = _getInitData(index, subIndex);
    value = UserGuildanceModel.custom(visible: data != null, anchorData: data);
  }

  /// return: 0: equal, 1: above, -1: less
  int compair(int index, int subIndex, int compairIndex, int compairSubIndex) {
    if (index > compairIndex) {
      return 1;
    } else if (index == compairIndex) {
      if (subIndex > compairSubIndex) {
        return 1;
      } else if (subIndex == compairSubIndex) {
        return 0;
      }
    }

    return -1;
  }

  AnchorData? _getInitData(int index, int subIndex) {
    AnchorData? minItem;
    if (_context != null) {
      var data = UserGuildanceAnchorInherit.of(_context!)?.data;
      if (data != null) {
        for (var item in data) {
          var compairResult =
              compair(item.index, item.subIndex ?? 0, index, subIndex);
          if (compairResult != -1) {
            if (minItem == null) {
              minItem = item;
            } else {
              compairResult = compair(item.index, item.subIndex ?? 0,
                  minItem.index, minItem.subIndex ?? 0);
              if (compairResult != 1) {
                minItem = item;
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
      return _getInitData(0, 0);
    } else {
      AnchorData? minItem;
      if (_context != null) {
        var data = UserGuildanceAnchorInherit.of(_context!)?.data;
        if (data != null) {
          for (var item in data) {
            var compairResult = compair(item.index, item.subIndex ?? 0,
                curData.index, curData.subIndex ?? 0);
            if (compairResult == 1) {
              if (minItem == null) {
                minItem = item;
              } else {
                compairResult = compair(item.index, item.subIndex ?? 0,
                    minItem.index, minItem.subIndex ?? 0);
                if (compairResult == -1) {
                  minItem = item;
                }
              }
            }
          }
        }
      }

      return minItem;
    }
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
}
