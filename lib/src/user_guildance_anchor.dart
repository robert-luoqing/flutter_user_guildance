import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'user_guildance_anchor_inherit.dart';

enum AnchorReportParentType { tab }

class UserGuildanceAnchor extends SingleChildRenderObjectWidget {
  const UserGuildanceAnchor(
      {Key? key,
      required Widget child,
      required this.index,
      this.subIndex,
      this.reportType,
      this.tag})
      : super(key: key, child: child);

  final int index;
  final int? subIndex;
  final AnchorReportParentType? reportType;
  final dynamic tag;

  @override
  RenderObject createRenderObject(BuildContext context) {
    var renderObj = _AnchorRenderObject(
        context: context,
        index: index,
        subIndex: subIndex,
        reportType: reportType,
        tag: tag);
    return renderObj;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    _AnchorRenderObject _anchorRenderObject =
        renderObject as _AnchorRenderObject;
    _anchorRenderObject.context = context;
    _anchorRenderObject.index = index;
    _anchorRenderObject.subIndex = subIndex;
    _anchorRenderObject.tag = tag;
    _anchorRenderObject.reportType = reportType;
    super.updateRenderObject(context, renderObject);
  }
}

class _AnchorRenderObject extends RenderShiftedBox {
  _AnchorRenderObject(
      {required this.context,
      RenderBox? child,
      required this.index,
      this.subIndex,
      this.reportType,
      this.tag})
      : super(child);

  BuildContext context;
  int index;
  int? subIndex;
  AnchorReportParentType? reportType;
  dynamic tag;

  void reportPosition(Offset point, Size size, dynamic tag) {
    UserGuildanceAnchorInherit.of(context)?.report(index, subIndex, point, size, tag);
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
    UserGuildanceAnchorInherit.of(context)?.remove(index, subIndex);
    super.dispose();
  }
}
