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
      this.group = 0})
      : super(key: key, child: child);

  final int step;
  final int? subStep;
  final AnchorReportParentType? reportType;
  final dynamic tag;
  final int group;

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
    super.updateRenderObject(context, renderObject);
  }
}

class _AnchorRenderObject extends RenderShiftedBox {
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

  void reportPosition(Offset point, Size size, dynamic tag) {
    var position = Rect.fromLTWH(point.dx, point.dy, size.width, size.height);
    if (adjustRect != null) {
      position = adjustRect!(position);
    }
    UserGuildanceAnchorInherit.of(context)
        ?.report(group, step, subStep, position, tag);
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
    try {
      if (reportType == null) {
        var positionObj = localToGlobal(const Offset(0, 0));
        reportPosition(positionObj, size, tag);
      } else if (reportType == AnchorReportParentType.tab) {
        var parentNode = parent;
        AbstractNode? prevNode;
        while (parentNode != null) {
          if (parentNode.runtimeType.toString() == "_TabLabelBarRenderer") {
            if (prevNode != null && prevNode is RenderBox) {
              var positionObj = prevNode.localToGlobal(const Offset(0, 0));
              reportPosition(positionObj, prevNode.size, tag);
              break;
            }
          }
          prevNode = parentNode;
          parentNode = parentNode.parent;
        }
      }
    } catch (e, s) {
      debugPrint("Fetch position error: $e, $s");
    }
  }

  @override
  void dispose() {
    UserGuildanceAnchorInherit.of(context)?.remove(step, subStep);
    super.dispose();
  }
}
