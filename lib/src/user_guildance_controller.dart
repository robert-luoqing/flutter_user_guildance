import 'package:flutter/material.dart';
import '../flutter_user_guildance.dart';
import 'user_guidance_condition.dart';

class UserGuidanceController extends ValueNotifier<UserGuildanceModel> {
  UserGuidanceController() : super(UserGuildanceModel());

  UserGuidanceState? _userGuidanceState;
  bool _disposed = false;

  void determineCurrentGuidance() {
    var current = value.current;
    if (current != null) {
      _updateUserGuidanceItemVisible(value.current);
      if (value.current!.visibleWithCondition) {
        notifyListeners();
        return;
      }
      value.stack.add(current);
      value.current = null;
    }

    for (var i = value.stack.length - 1; i >= 0; i--) {
      var item = value.stack[i];
      if (current != item) {
        _updateUserGuidanceItemVisible(item);
        if (item.visibleWithCondition) {
          value.current = item;
          value.stack.removeAt(i);
          notifyListeners();
          return;
        }
      }
    }

    // If current still null
    if (value.current == null) {
      Map<int, String> anchorPageConditions =
          _userGuidanceState?.widget.anchorPageConditions ?? {};
      for (var i = value.stack.length - 1; i >= 0; i--) {
        var item = value.stack[i];
        var isMatched = false;
        // No page, the priority is going to should no page item
        if (value.currentPage.isEmpty) {
          if (!anchorPageConditions.containsKey(item.data.group)) {
            isMatched = true;
          }
        } else {
          if (anchorPageConditions[item.data.group] == value.currentPage) {
            isMatched = true;
          }
        }

        if (isMatched) {
          value.current = item;
          value.stack.removeAt(i);
          notifyListeners();
          return;
        }
      }
    }

    notifyListeners();
  }

  void removeMatchedGuidanceItem(int group) {
    if (value.current != null) {
      if (value.current!.data.group == group) {
        value.current = null;
      } else {
        for (var i = value.stack.length - 1; i >= 0; i--) {
          var item = value.stack[i];
          if (item.data.group == group) {
            value.stack.removeAt(i);
            break;
          }
        }
      }
    }
  }

  set currentPage(String? page) {
    if (value.currentPage != page) {
      value.currentPage = page ?? "";
      determineCurrentGuidance();
    }
  }

  String get currentPage {
    return value.currentPage;
  }

  void show({int group = 0, int index = 0, int subIndex = 0}) {
    var data = _getInitData(group, index, subIndex);
    removeMatchedGuidanceItem(group);

    /// Put exist current to stack
    if (value.current != null) {
      value.stack.add(value.current!);
    }
    if (data != null) {
      value.current =
          UserGuildanceItemModel(visibleWithCondition: false, data: data);
    }

    determineCurrentGuidance();
  }

  void next() {
    if (value.current != null) {
      var data = _getNextData(value.current!.data);
      if (data == null) {
        value.current = null;
      } else {
        value.current!.data = data;
      }
    }
    if (value.current == null) {
      determineCurrentGuidance();
    } else {
      notifyListeners();
    }
  }

  /// group is null, it mean close all group
  void hide({int? group}) {
    if (group == null) {
      value.current = null;
      value.stack.clear();
    } else {
      removeMatchedGuidanceItem(group);
    }
    determineCurrentGuidance();
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

  void _updateUserGuidanceItemVisible(UserGuildanceItemModel? item) {
    if (item != null) {
      item.visibleWithCondition = checkIsMatchConditin(
        visible: true,
        currentAnchorData: item.data,
        currentPage: value.currentPage,
        anchorDatas: _userGuidanceState?.anchorDatas ?? [],
        anchorPageConditions: _userGuidanceState?.widget.anchorPageConditions,
        anchorAppearConditions:
            _userGuidanceState?.widget.anchorAppearConditions,
        anchorPositionConditions:
            _userGuidanceState?.widget.anchorPositionConditions,
      );
    }
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
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

  AnchorData? _getNextData(AnchorData curData) {
    AnchorData? minItem;
    var groupAchors = getFullAnchorDatas(curData.group);

    for (var item in groupAchors) {
      var compairResult = compair(
          item.step, item.subStep ?? 0, curData.step, curData.subStep ?? 0);
      if (compairResult == 1) {
        if (minItem == null) {
          minItem = item;
        } else {
          compairResult = compair(
              item.step, item.subStep ?? 0, minItem.step, minItem.subStep ?? 0);
          if (compairResult == -1) {
            minItem = item;
          }
        }
      }
    }

    return minItem;
  }
}
