import 'package:flutter/material.dart';
import '../flutter_user_guildance.dart';

class UserGuidanceController extends ValueNotifier<UserGuildanceModel> {
  UserGuidanceController() : super(UserGuildanceModel(visible: false));

  UserGuidanceState? _userGuidanceState;

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

  void attach(UserGuidanceState instance) {
    if (_userGuidanceState != instance) {
      _userGuidanceState = instance;
    }
  }

  void detach() {
    if (_userGuidanceState != null) {
      _userGuidanceState = null;
    }
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
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

  List<AnchorData> getFullAnchorDatas(int group) {
    var result = <AnchorData>[];
    if (_userGuidanceState != null) {
      var data = _userGuidanceState?.anchorDatas;
      if (data != null) {
        for (var item in data) {
          if (item.group == group) {
            result.add(item);
          }
        }
      }

      /// Handle appear condition
      var appearConditions = _userGuidanceState!.widget.anchorAppearConditions;
      if (appearConditions != null) {
        intergrateConditionAnchorData(group, appearConditions[group], result);
      }

      /// Handle appear condition
      var positionConditions =
          _userGuidanceState!.widget.anchorPositionConditions;
      if (positionConditions != null && positionConditions.containsKey(group)) {
        intergrateConditionAnchorData(group, positionConditions[group], result);
      }

      // intergrate customAnchors
      List<UserGuildanceCustomAnchor> customAnchors =
          _userGuidanceState?.widget.customAnchors ?? [];
      for (var anchor in customAnchors) {
        if (anchor.group == group) {
          result.add(AnchorData(
              group: group,
              step: anchor.step,
              subStep: anchor.subStep,
              position: anchor.position,
              tag: anchor.tag,
              type: AnchorDataType.custom));
        }
      }

      return result;
    }
    return result;
  }

  void intergrateConditionAnchorData(int group,
      List<UserGuidanceCondition>? conditions, List<AnchorData> result) {
    if (conditions != null) {
      for (var condition in conditions) {
        bool matched = false;
        for (var item in result) {
          if (item.step == condition.step &&
              item.subStep == condition.subStep) {
            matched = true;
            break;
          }
        }
        if (!matched) {
          result.add(AnchorData(
              group: group,
              step: condition.step,
              subStep: condition.subStep,
              position: Rect.zero));
        }
      }
    }
  }

  AnchorData? _getInitData(int group, int step, int subStep) {
    AnchorData? minItem;

    var groupAchors = getFullAnchorDatas(group);
    for (var item in groupAchors) {
      var compairResult = compair(item.step, item.subStep ?? 0, step, subStep);
      if (compairResult != -1) {
        if (minItem == null) {
          minItem = item;
        } else {
          compairResult = compair(
              item.step, item.subStep ?? 0, minItem.step, minItem.subStep ?? 0);
          if (compairResult != 1) {
            minItem = item;
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
      var groupAchors = getFullAnchorDatas(curData.group);

      for (var item in groupAchors) {
        var compairResult = compair(
            item.step, item.subStep ?? 0, curData.step, curData.subStep ?? 0);
        if (compairResult == 1) {
          if (minItem == null) {
            minItem = item;
          } else {
            compairResult = compair(item.step, item.subStep ?? 0, minItem.step,
                minItem.subStep ?? 0);
            if (compairResult == -1) {
              minItem = item;
            }
          }
        }
      }

      return minItem;
    }
  }
}
