import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../flutter_user_guildance.dart';

typedef UserGuildanceTipBuilder = Widget? Function(
    BuildContext context, AnchorData? data);
typedef UserGuildanceDecorationBuilder = Decoration? Function(
    BuildContext context, AnchorData? data);

class UserGuidanceCondition {
  UserGuidanceCondition({required this.step, this.subStep});
  final int step;
  final int? subStep;
}

class UserGuidancePositionCondition extends UserGuidanceCondition {
  UserGuidancePositionCondition(
      {required int step,
      int? subStep,
      this.minX,
      this.minY,
      this.maxX,
      this.maxY})
      : super(step: step, subStep: subStep);

  /// if [minY],[maxY] both is -1, It meaning should it appear in scroll view
  final double? minX;
  final double? minY;
  final double? maxX;
  final double? maxY;
}

class UserGuidanceAppearCondition extends UserGuidanceCondition {
  UserGuidanceAppearCondition({required int step, int? subStep})
      : super(step: step, subStep: subStep);
}

class UserGuildanceCustomAnchor {
  UserGuildanceCustomAnchor(
      {required this.group,
      required this.step,
      this.subStep,
      required this.position,
      this.tag});
  int group;
  int step;
  int? subStep;
  Rect position;
  dynamic tag;
}

class UserGuidance extends StatefulWidget {
  const UserGuidance(
      {Key? key,
      required this.controller,
      required this.child,
      this.duration = const Duration(milliseconds: 200),
      this.tipBuilder,
      this.slotBuilder,
      this.opacity = 0.4,
      this.anchorAppearConditions,
      this.anchorPositionConditions,
      this.anchorPageConditions,
      this.showMaskWhenMissCondition = false,
      this.moveNextOnTap = true,
      this.customAnchors,
      this.module,
      this.useModalAsMask = false})
      : super(key: key);

  final Widget child;
  final UserGuidanceController controller;
  final Duration duration;
  final UserGuildanceTipBuilder? tipBuilder;
  final UserGuildanceDecorationBuilder? slotBuilder;

  final double opacity;

  /// true: move next when tap mask or item
  final bool moveNextOnTap;

  /// If [anchorAppearConditions] or [anchorPositionConditions] is not null,
  /// and controller.show invoked, The user guidance will not show up.
  /// Exception meet the conditions. Before meeting condition,
  /// if [showMaskWhenMissCondition] is true, The mask will show up.
  /// Otherwise the user guidance will keep hidden
  /// The user guidance will appear when the group condition meet
  final Map<int, List<UserGuidanceAppearCondition>>? anchorAppearConditions;
  final Map<int, List<UserGuidancePositionCondition>>? anchorPositionConditions;
  final Map<int, String>? anchorPageConditions;
  final bool showMaskWhenMissCondition;

  final List<UserGuildanceCustomAnchor>? customAnchors;

  /// If anchor have module, the UserGuidance only receive same module data
  final String? module;

  final bool useModalAsMask;

  @override
  UserGuidanceState createState() => UserGuidanceState();
}

class UserGuidanceState extends State<UserGuidance> {
  /// Anchor data
  final List<AnchorData> anchorDatas = [];

  /// Does the dialog is show up
  BuildContext? _dialogContext;

  @override
  void initState() {
    super.initState();
    widget.controller.attach(this);
    widget.controller.addListener(monitorGuidanceValueChange);
  }

  @override
  void didUpdateWidget(covariant UserGuidance oldWidget) {
    if (widget.controller != oldWidget.controller) {
      widget.controller.attach(this);
      oldWidget.controller.detach();
      widget.controller.addListener(monitorGuidanceValueChange);
      oldWidget.controller.removeListener(monitorGuidanceValueChange);
    }

    super.didUpdateWidget(oldWidget);
  }

  void onUpReport(int group, int step, int? subStep, Rect position, dynamic tag,
      bool? inScrollZone, String? anchorModule) {
    var anchorObject = UserGuildanceAnchorInherit.of(context);
    anchorObject?.report(
        group, step, subStep, position, tag, inScrollZone, anchorModule);
  }

  void onPositionChanged(AnchorData data, bool isNew) {
    var curAnchorData = widget.controller.value.current?.data;
    if (curAnchorData != null) {
      if (curAnchorData.group == data.group) {
        if (curAnchorData.step == data.step &&
            curAnchorData.subStep == data.subStep) {
          widget.controller.value.current!.data = data;
        }

        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            widget.controller.determineCurrentGuidance();
            widget.controller.notifyListeners();
          },
        );
      }
    } else {
      if (widget.controller.value.stack.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            widget.controller.determineCurrentGuidance();
            widget.controller.notifyListeners();
          },
        );
      }
    }
  }

  Widget? getDefaultTipWidget(context, data) {
    if (data != null) {
      return TipWidget(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text("${data.tag}")),
        data: data,
      );
    }

    return null;
  }

  Widget valueListenableBuilder(_, value, child) {
    late Widget renderChild;
    if (value.current?.visibleWithCondition ?? false) {
      renderChild = SizedBox(key: const ValueKey("switch_1"), child: child);
    } else {
      if (value.current != null && widget.showMaskWhenMissCondition) {
        renderChild = SizedBox(
            key: const ValueKey("switch_2"),
            child: Container(
              color: Colors.black54,
              child: const Center(
                  child: CupertinoActivityIndicator(
                radius: 15,
              )),
            ));
      } else {
        renderChild = const SizedBox(key: ValueKey("switch_2"));
      }
    }

    return AnimatedSwitcher(
      duration: widget.duration,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: renderChild,
    );
  }

  Widget buildBackgroundAndRect() {
    return Positioned.fill(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Color.fromARGB((widget.opacity * 255.0).toInt(), 0, 0, 0),
          BlendMode.srcOut,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
            ),
            ValueListenableBuilder<UserGuildanceModel>(
              valueListenable: widget.controller,
              builder: (context, value, child) {
                final anchorData = value.current?.data;
                var rect = Rect.fromLTWH(
                    anchorData?.position.left ?? 0,
                    anchorData?.position.top ?? 0,
                    anchorData?.position.width ?? 0,
                    anchorData?.position.height ?? 0);
                Decoration? decoration;
                if (widget.slotBuilder != null) {
                  decoration = widget.slotBuilder!(context, anchorData);
                }
                decoration ??= const BoxDecoration(color: Colors.white);

                return AnimatedPositioned.fromRect(
                  duration: widget.duration,
                  rect: rect,
                  child: AnimatedContainer(
                    duration: widget.duration,
                    decoration: decoration,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTipUI() {
    return Material(
      color: Colors.transparent,
      child: ValueListenableBuilder<UserGuildanceModel>(
        valueListenable: widget.controller,
        builder: (context, value, child) {
          final anchorData = value.current?.data;
          Widget? tipWidget;
          if (widget.tipBuilder != null) {
            tipWidget = widget.tipBuilder!(context, anchorData);
          } else {
            if (anchorData?.tag != null) {
              tipWidget = getDefaultTipWidget(context, anchorData);
            }
          }

          tipWidget ??= Container();

          return AnimatedSwitcher(
            duration: widget.duration,
            child: SizedBox(
              key: ValueKey(
                  "${value.current?.data.step}-${value.current?.data.subStep}"),
              child: tipWidget,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useModalAsMask) {
      return UserGuildanceAnchorInherit(
          anchorDatas: anchorDatas,
          onPositionChanged: onPositionChanged,
          module: widget.module,
          onUpReport: onUpReport,
          child: Stack(children: [
            widget.child,
          ]));
    } else {
      return UserGuildanceAnchorInherit(
          anchorDatas: anchorDatas,
          onPositionChanged: onPositionChanged,
          module: widget.module,
          onUpReport: onUpReport,
          child: Stack(children: [
            widget.child,
            Positioned.fill(
                child: ValueListenableBuilder<UserGuildanceModel>(
              valueListenable: widget.controller,
              builder: valueListenableBuilder,
              child: GestureDetector(
                  onTap: _handlePressed,
                  child: Stack(
                    children: [buildBackgroundAndRect(), buildTipUI()],
                  )),
            ))
          ]));
    }
  }

  void monitorGuidanceValueChange() {
    var step = widget.controller.value.current?.data.step;
    if (kDebugMode) {
      print("monitorGuidanceValueChange step: $step");
    }
    if (widget.useModalAsMask == false) {
      return;
    }

    if (step != null && _dialogContext == null) {
      showGeneralDialog(
        context: context,
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        pageBuilder: (context, __, ___) {
          _dialogContext = context;
          return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.transparent,
              child: ValueListenableBuilder<UserGuildanceModel>(
                valueListenable: widget.controller,
                builder: valueListenableBuilder,
                child: GestureDetector(
                    onTap: _handlePressed,
                    child: Stack(
                      children: [buildBackgroundAndRect(), buildTipUI()],
                    )),
              ));
        },
      );
    }
    if (step == null && _dialogContext != null) {
      Navigator.pop(_dialogContext!);
      _dialogContext = null;
    }
  }

  void _handlePressed() {
    if (widget.moveNextOnTap) {
      widget.controller.next();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(monitorGuidanceValueChange);
  }
}
