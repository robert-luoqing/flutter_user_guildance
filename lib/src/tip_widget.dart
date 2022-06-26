import 'package:flutter/material.dart';

import '../flutter_user_guildance.dart';
import 'measure_size.dart';

class TipWidget extends StatefulWidget {
  const TipWidget(
      {Key? key,
      required this.data,
      required this.child,
      this.arrowWidth = 10.0,
      this.arrowHeight = 10.0,
      this.radius = const Radius.circular(4.0),
      this.bkColor = Colors.white})
      : super(key: key);

  final AnchorData data;
  final Widget child;
  final Color bkColor;
  final Radius radius;
  final double arrowWidth;
  final double arrowHeight;

  @override
  State<TipWidget> createState() => _TipWidgetState();
}

class _TipWidgetState extends State<TipWidget> {
  var tipTop = 0.0;
  var tipLeft = 0.0;
  var arrowPosition = 0.0;
  var arrowWidth = 7.0;
  var childSize = Size.zero;

  var bubbleDirection = BubbleDirection.left;

  Rect get position => widget.data.position;

  void onChange(Size contentSize) {
    childSize = contentSize;
    calcPosition();
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant TipWidget oldWidget) {
    calcPosition();
    super.didUpdateWidget(oldWidget);
  }

  void calcPosition() {
    var screenSize = MediaQuery.of(context).size;
    var leftSpace = position.left;
    var rightSpace = screenSize.width - (position.left + position.width);
    var topSpace = position.top;
    var bottomSpace = screenSize.height - (position.top + position.height);
    var direction = BubbleDirection.left;
    var targetSpace = leftSpace;
    if (rightSpace > targetSpace) {
      direction = BubbleDirection.right;
      targetSpace = rightSpace;
    }

    if (topSpace > targetSpace) {
      direction = BubbleDirection.top;
      targetSpace = topSpace;
    }
    if (bottomSpace > targetSpace) {
      direction = BubbleDirection.bottom;
      targetSpace = bottomSpace;
    }

    // calc the tip position
    switch (direction) {
      case BubbleDirection.left:
        bubbleDirection = BubbleDirection.right;
        tipLeft = position.left - childSize.width;
        calcTipTop(childSize, screenSize);
        break;
      case BubbleDirection.right:
        bubbleDirection = BubbleDirection.left;
        tipLeft = position.left + position.width;
        calcTipTop(childSize, screenSize);
        break;
      case BubbleDirection.top:
        bubbleDirection = BubbleDirection.bottom;
        tipTop = position.top - childSize.height;
        calcTipLeft(childSize, screenSize);
        break;
      case BubbleDirection.bottom:
        bubbleDirection = BubbleDirection.top;
        tipTop = position.top + position.height;
        calcTipLeft(childSize, screenSize);
        break;
    }
  }

  void calcTipTop(Size childSize, Size screenSize) {
    tipTop = position.top + position.height / 2.0 - childSize.height / 2.0;
    arrowPosition = childSize.height / 2.0 - arrowWidth / 2.0;
    if (tipTop < 10) {
      tipTop = 10.0;
    } else if (tipTop > (screenSize.height - 10.0 - childSize.height)) {
      tipTop = screenSize.height - 10.0 - childSize.height;
    }

    arrowPosition = position.top - tipTop + position.height / 2.0;
  }

  void calcTipLeft(Size childSize, Size screenSize) {
    tipLeft = position.left + position.width / 2.0 - childSize.width / 2.0;
    arrowPosition = childSize.width / 2.0 - arrowWidth / 2.0;
    if (tipLeft < 10) {
      tipLeft = 10;
    } else if (tipLeft > (screenSize.width - 10.0 - childSize.width)) {
      tipLeft = screenSize.width - (10.0 + childSize.width);
    }
    arrowPosition = position.left - tipLeft + position.width / 2.0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        left: tipLeft,
        top: tipTop,
        child: MeasureSize(
          onChange: onChange,
          child: BubbleWidget(
              bkColor: widget.bkColor,
              arrowPosition: arrowPosition,
              direction: bubbleDirection,
              radius: widget.radius,
              arrowHeight: widget.arrowHeight,
              arrowWidth: widget.arrowWidth,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.child,
              )),
        ),
      )
    ]);
  }
}
