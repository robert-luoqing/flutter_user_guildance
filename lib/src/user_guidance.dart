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
  }) : super(key: key);

  final UserGuidanceController controller;
  final Duration duration;
  final UserGuildanceTipBuilder? tipBuilder;
  final UserGuildanceDecorationBuilder? slotBuilder;
  final Widget child;

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
          slotBuilder: widget.slotBuilder,)
    ]));
  }
}
