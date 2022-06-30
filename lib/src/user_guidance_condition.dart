import '../flutter_user_guildance.dart';

bool _determinePageCondition(AnchorData? anchorData, String? currentPage,
    Map<int, String>? anchorPageConditions) {
  if (anchorData != null && anchorPageConditions != null) {
    var groupBelongPage = anchorPageConditions[anchorData.group];
    if (groupBelongPage != null) {
      if (groupBelongPage != currentPage) {
        return false;
      }
    }
  }

  return true;
}

bool _determineAppearCondition(
    AnchorData? anchorData,
    Map<int, List<UserGuidanceAppearCondition>>? anchorAppearConditions,
    List<AnchorData> anchorDatas) {
  if (anchorData != null &&
      anchorAppearConditions != null &&
      anchorAppearConditions.isNotEmpty) {
    var group = anchorData.group;
    var groupAppearCondition = anchorAppearConditions[group];
    if (groupAppearCondition != null && groupAppearCondition.isNotEmpty) {
      // Here is check the conditions
      var reportDatas = anchorDatas;
      for (var condition in groupAppearCondition) {
        var matched = false;
        for (var reportData in reportDatas) {
          if (condition.step == reportData.step &&
              condition.subStep == reportData.subStep) {
            matched = true;
            break;
          }
        }
        if (matched == false) {
          return false;
        }
      }
    }
  }

  return true;
}

bool _determinePositionCondition(
    AnchorData? anchorData,
    Map<int, List<UserGuidancePositionCondition>>? anchorPositionConditions,
    List<AnchorData> anchorDatas) {
  if (anchorData != null &&
      anchorPositionConditions != null &&
      anchorPositionConditions.isNotEmpty) {
    var group = anchorData.group;
    var groupPositionCondition = anchorPositionConditions[group];
    if (groupPositionCondition != null && groupPositionCondition.isNotEmpty) {
      // Here is check the conditions
      var reportDatas = anchorDatas;
      for (var condition in groupPositionCondition) {
        var matched = false;
        for (var reportData in reportDatas) {
          if (condition.step == reportData.step &&
              condition.subStep == reportData.subStep) {
            var minX = condition.minX ?? -10000000.0;
            var minY = condition.minY ?? -10000000.0;
            var maxX = condition.maxX ?? double.maxFinite;
            var maxY = condition.maxY ?? double.maxFinite;

            if (minX == -1 && minY == -1 && maxX == -1 && maxY == -1) {
              if (reportData.inScrollZone ?? false) {
                matched = true;
              } else {
                return false;
              }
            } else {
              if (minX <= reportData.position.left &&
                  maxX >= reportData.position.right &&
                  minY <= reportData.position.top &&
                  maxY >= reportData.position.bottom) {
                matched = true;
              } else {
                return false;
              }
            }

            break;
          }
        }
        if (matched == false) {
          return false;
        }
      }
    }
  }

  return true;
}

bool checkIsMatchConditin({
  required bool visible,
  AnchorData? currentAnchorData,
  String? currentPage,
  required List<AnchorData> anchorDatas,
  Map<int, String>? anchorPageConditions,
  Map<int, List<UserGuidanceAppearCondition>>? anchorAppearConditions,
  Map<int, List<UserGuidancePositionCondition>>? anchorPositionConditions,
}) {
  if (visible) {
    visible = _determinePageCondition(
        currentAnchorData, currentPage, anchorPageConditions);
  }
  if (visible) {
    visible = _determineAppearCondition(
        currentAnchorData, anchorAppearConditions, anchorDatas);
  }

  if (visible) {
    visible = _determinePositionCondition(
        currentAnchorData, anchorPositionConditions, anchorDatas);
  }

  return visible;
}
