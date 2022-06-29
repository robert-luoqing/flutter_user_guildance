import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'user_guildance_anchor_inherit.dart';

enum AnchorReportParentType { tab }

typedef AnchorAdjustRect = Rect Function(Rect);

class UserGuildanceAnchor extends SingleChildRenderObjectWidget {
  const UserGuildanceAnchor(
      {Key? key,
      required Widget child,
      required this.step,
      this.subStep,
      this.reportType,
      this.adjustRect,
      this.tag,
      this.group = 0,
      this.needMonitorScroll = false})
      : super(key: key, child: child);

  final int step;
  final int? subStep;
  final AnchorReportParentType? reportType;
  final dynamic tag;
  final int group;

  /// It will effect performance. If the item is not in list view or scroll,
  /// Should keep it to false
  final bool needMonitorScroll;

  final AnchorAdjustRect? adjustRect;

  @override
  RenderObject createRenderObject(BuildContext context) {
    var renderObj = _AnchorRenderObject(
        context: context,
        step: step,
        subStep: subStep,
        reportType: reportType,
        adjustRect: adjustRect,
        tag: tag,
        group: group);
    renderObj.needMonitorScroll = needMonitorScroll;
    return renderObj;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    _AnchorRenderObject _anchorRenderObject =
        renderObject as _AnchorRenderObject;
    _anchorRenderObject.context = context;
    _anchorRenderObject.step = step;
    _anchorRenderObject.subStep = subStep;
    _anchorRenderObject.tag = tag;
    _anchorRenderObject.reportType = reportType;
    _anchorRenderObject.adjustRect = adjustRect;
    _anchorRenderObject.group = group;
    _anchorRenderObject.needMonitorScroll = needMonitorScroll;
    super.updateRenderObject(context, renderObject);
  }
}

class _AnchorRenderObject extends RenderShiftedBox {
  UserGuildanceAnchorInherit? anchorObject;
  ScrollPosition? scrollPosition;
  _AnchorRenderObject(
      {required this.context,
      RenderBox? child,
      required this.step,
      this.subStep,
      this.reportType,
      this.adjustRect,
      required this.group,
      this.tag})
      : super(child);

  BuildContext context;
  int step;
  int? subStep;
  AnchorReportParentType? reportType;
  dynamic tag;
  AnchorAdjustRect? adjustRect;
  int group;

  bool _needMonitorScroll = false;

  /// It will effect performance. If the item is not in list view or scroll,
  /// Should keep it to false
  set needMonitorScroll(status) {
    if (status != _needMonitorScroll) {
      _needMonitorScroll = status;
      if (status) {
        var newScrollPosition = Scrollable.of(context)?.position;
        if (scrollPosition != newScrollPosition) {
          if (scrollPosition != null) {
            scrollPosition!.removeListener(monitorParentScroll);
          }
          scrollPosition = newScrollPosition;
          if (scrollPosition != null) {
            scrollPosition!.addListener(monitorParentScroll);
          }
        }
      } else {
        if (scrollPosition != null) {
          scrollPosition!.removeListener(monitorParentScroll);
        }
        scrollPosition = null;
      }
    }
  }

  void monitorParentScroll() {
    if (scrollPosition != null) {
      handleReportPosition();
    }
  }

  void reportPosition(
      Offset point, Size size, dynamic tag, bool? inScrollZone) {
    var position = Rect.fromLTWH(point.dx, point.dy, size.width, size.height);
    if (adjustRect != null) {
      position = adjustRect!(position);
    }
    anchorObject ??= UserGuildanceAnchorInherit.of(context);
    anchorObject?.report(group, step, subStep, position, tag, inScrollZone);
  }

  RenderBox? findParentRenderObject(String name, bool returnPrev) {
    var parentNode = parent;
    AbstractNode? prevNode;
    while (parentNode != null) {
      var runtimeType = parentNode.runtimeType.toString();
      if (runtimeType == name) {
        if (returnPrev) {
          if (prevNode != null && prevNode is RenderBox) {
            return prevNode;
          }
          return null;
        } else {
          if (parentNode is RenderBox) {
            return parentNode;
          }
          return null;
        }
      }
      prevNode = parentNode;
      parentNode = parentNode.parent;
    }
    return null;
  }

  handleReportPosition() {
    try {
      if (reportType == null) {
        var positionObj = localToGlobal(const Offset(0, 0));
        bool? inScrollZone;
        if (scrollPosition != null) {
          var matchedNode = findParentRenderObject("RenderViewport", false);
          if (matchedNode != null) {
            var translation = getTransformTo(matchedNode).getTranslation();
            var rect = paintBounds.shift(Offset(translation.x, translation.y));
            var viewportSize = matchedNode.size;
            if (rect.top >= 0 &&
                rect.left >= 0 &&
                rect.right <= viewportSize.width &&
                rect.bottom <= viewportSize.height) {
              inScrollZone = true;
            } else {
              inScrollZone = false;
            }
          }
        }

        reportPosition(positionObj, size, tag, inScrollZone);
      } else if (reportType == AnchorReportParentType.tab) {
        var matchedNode = findParentRenderObject("_TabLabelBarRenderer", true);
        if (matchedNode != null) {
          var positionObj = matchedNode.localToGlobal(const Offset(0, 0));
          reportPosition(positionObj, matchedNode.size, tag, null);
        }
      }
    } catch (e, s) {
      debugPrint("Fetch position error: $e, $s");
    }
  }

  @override
  void performLayout() {
    child!.layout(
      constraints.copyWith(
        maxWidth: constraints.maxWidth,
        minWidth: constraints.minWidth,
        maxHeight: constraints.maxHeight,
        minHeight: constraints.minHeight,
      ),
      parentUsesSize: true,
    );

    size = constraints.constrain(Size(child!.size.width, child!.size.height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    handleReportPosition();
  }

  @override
  void dispose() {
    anchorObject?.remove(step, subStep);
    if (scrollPosition != null) {
      scrollPosition!.removeListener(monitorParentScroll);
    }
    super.dispose();
  }
}
