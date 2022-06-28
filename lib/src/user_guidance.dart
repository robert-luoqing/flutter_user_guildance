import 'package:flutter/material.dart';
import 'user_guildance_inner.dart';

import 'user_guildance_anchor_inherit.dart';
import 'user_guildance_controller.dart';

class UserGuidance extends StatefulWidget {
  const UserGuidance({
    Key? key,
    required this.controller,
    required this.child,
    this.duration = const Duration(milliseconds: 250),
    this.tipBuilder,
    this.slotBuilder,
    this.opacity = 0.4,
    this.anchorAppearConditions,
    this.anchorPositionConditions,
    this.showMaskWhenMissCondition = true,
    this.moveNextOnTap = true,
  }) : super(key: key);

  final UserGuidanceController controller;
  final Duration duration;
  final UserGuildanceTipBuilder? tipBuilder;
  final UserGuildanceDecorationBuilder? slotBuilder;
  final Widget child;
  final double opacity;

  /// true: move next when tap mask or item
  final bool moveNextOnTap;

  /// If [anchorAppearConditions] or [anchorPositionConditions] is not null,
  /// and controller.show invoked, The user guildance will not show up.
  /// Exception meet the conditions. Before meeting condition,
  /// if [showMaskWhenMissCondition] is true, The mask will show up.
  /// Otherwise the user guildance will keep hidden
  /// The user guildance will appear when the group condition meet
  final Map<int, List<int>>? anchorAppearConditions;
  final Map<int, List<UserGuidancePositionCondition>>? anchorPositionConditions;
  final bool showMaskWhenMissCondition;

  @override
  _UserGuidanceState createState() => _UserGuidanceState();
}

class _UserGuidanceState extends State<UserGuidance> {
  @override
  Widget build(BuildContext context) {
    return UserGuildanceAnchorInherit(
        child: Stack(children: [
      widget.child,
      UserGuidanceInner(
          controller: widget.controller,
          duration: widget.duration,
          tipBuilder: widget.tipBuilder,
          slotBuilder: widget.slotBuilder,
          opacity: widget.opacity,
          anchorAppearConditions: widget.anchorAppearConditions,
          anchorPositionConditions: widget.anchorPositionConditions,
          showMaskWhenMissCondition: widget.showMaskWhenMissCondition,
          moveNextOnTap: widget.moveNextOnTap)
    ]));
  }
}
