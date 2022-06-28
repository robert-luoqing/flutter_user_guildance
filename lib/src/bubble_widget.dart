import 'package:flutter/material.dart';

enum ArrowPositionBasedType {
  start,
  center,
  end,
}

typedef BubbleWidgetChildBuilder = Widget Function(
    BuildContext, BubbleDirection);

class BubbleWidget extends StatelessWidget {
  const BubbleWidget({
    Key? key,
    this.direction = BubbleDirection.left,
    this.arrowWidth = 10.0,
    this.arrowHeight = 10.0,
    this.arrowPosition = 20.0,
    this.arrowPositionBased = ArrowPositionBasedType.start,
    this.topLeftRadius = const Radius.circular(4.0),
    this.topRightRadius = const Radius.circular(4.0),
    this.bottomLeftRadius = const Radius.circular(4.0),
    this.bottomRightRadius = const Radius.circular(4.0),
    this.clipPadding = const EdgeInsets.all(0),
    this.decoration,
    this.child,
    this.childBuilder,
  }) : super(key: key);

  final BubbleDirection direction; // 箭头方向
  final Widget? child;
  final BubbleWidgetChildBuilder? childBuilder;

  final double arrowWidth;
  final double arrowHeight;

  final double arrowPosition;
  final ArrowPositionBasedType arrowPositionBased;

  final Radius topLeftRadius;
  final Radius topRightRadius;
  final Radius bottomLeftRadius;
  final Radius bottomRightRadius;

  /// 这个bk部分的Padding
  final EdgeInsetsGeometry clipPadding;
  final Decoration? decoration;

  final _minHeight = 32.0; // 内容最小高度
  final _minWidth = 50.0; // 内容最小宽度

  @override
  Widget build(BuildContext context) {
    var paddingTop = 0.0;
    var paddingBottom = 0.0;
    var paddingLeft = 0.0;
    var paddingRight = 0.0;
    switch (direction) {
      case BubbleDirection.left:
        paddingLeft = arrowHeight;
        break;
      case BubbleDirection.right:
        paddingRight = arrowHeight;
        break;
      case BubbleDirection.top:
        paddingTop = arrowHeight;
        break;
      case BubbleDirection.bottom:
        paddingBottom = arrowHeight;
        break;
    }

    Widget? content = child;
    if (content == null && childBuilder != null) {
      content = childBuilder!(context, direction);
    }
    content ??= Container();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Padding(
              padding: clipPadding,
              child: ClipPath(
                  clipper: _BubbleClipper(
                      direction: direction,
                      topLeftRadius: topLeftRadius,
                      topRightRadius: topRightRadius,
                      bottomLeftRadius: bottomLeftRadius,
                      bottomRightRadius: bottomRightRadius,
                      arrowWidth: arrowWidth,
                      arrowHeight: arrowHeight,
                      arrowPosition: arrowPosition,
                      arrowPositionBased: arrowPositionBased),
                  child: Container(
                    decoration:
                        decoration ?? const BoxDecoration(color: Colors.white),
                  )),
            )),
        Container(
            constraints: (const BoxConstraints())
                .copyWith(minHeight: _minHeight, minWidth: _minWidth),
            child: Padding(
              padding: EdgeInsets.only(
                  left: paddingLeft,
                  right: paddingRight,
                  top: paddingTop,
                  bottom: paddingBottom),
              child: content,
            )),
      ],
    );
  }
}

// 方向
enum BubbleDirection { left, right, top, bottom }

class _BubbleClipper extends CustomClipper<Path> {
  final BubbleDirection direction;
  final double arrowWidth;
  final double arrowHeight;
  final Radius topLeftRadius;
  final Radius topRightRadius;
  final Radius bottomLeftRadius;
  final Radius bottomRightRadius;
  final double arrowPosition;
  final ArrowPositionBasedType arrowPositionBased;
  _BubbleClipper(
      {required this.direction,
      required this.topLeftRadius,
      required this.topRightRadius,
      required this.bottomLeftRadius,
      required this.bottomRightRadius,
      required this.arrowWidth,
      required this.arrowHeight,
      required this.arrowPosition,
      required this.arrowPositionBased});

  @override // 获取裁剪
  Path getClip(Size size) {
    final path = Path();
    final path2 = Path();

    if (direction == BubbleDirection.left) {
      _paintLeftAndRight(size, path, path2, 0, arrowHeight, arrowHeight, true);
    } else if (direction == BubbleDirection.right) {
      _paintLeftAndRight(
          size, path, path2, size.width, size.width - arrowHeight, 0, false);
    } else if (direction == BubbleDirection.top) {
      _paintTopAndBottom(size, path, path2, 0, arrowHeight, arrowHeight, true);
    } else {
      _paintTopAndBottom(
          size, path, path2, size.height, size.height - arrowHeight, 0, false);
    }
    return path;
  }

  _paintLeftAndRight(Size size, Path path, Path path2, double arrowPointX,
      double arrowBottomX, double leftX, bool isLeft) {
    double startPoint = 0;
    if (size.height > arrowWidth) {
      switch (arrowPositionBased) {
        case ArrowPositionBasedType.start:
          startPoint = arrowPosition - arrowWidth / 2.0;
          break;
        case ArrowPositionBasedType.center:
          startPoint = size.height / 2 + arrowPosition - arrowWidth / 2.0;
          break;
        case ArrowPositionBasedType.end:
          startPoint = size.height - arrowPosition - arrowWidth / 2.0;
          break;
      }
    }

    var endPoint = startPoint + arrowWidth;
    var arrowPoint = startPoint + arrowWidth / 2;
    if (endPoint < arrowWidth / 2) {
      endPoint = arrowWidth / 2;
    }
    if (startPoint > (size.height - arrowWidth / 2)) {
      startPoint = (size.height - arrowWidth / 2);
    }

    if (startPoint < 0) {
      startPoint = 0;
    }
    if (endPoint > size.height) {
      endPoint = size.height;
    }

    path.moveTo(arrowBottomX, startPoint);
    path.lineTo(arrowBottomX, endPoint);
    path.lineTo(arrowPointX, arrowPoint);
    path.close();
    //绘制矩形
    var mTopLeftRadius = topLeftRadius;
    var mTopRightRadius = topRightRadius;
    var mBottomLeftRadius = bottomLeftRadius;
    var mBottomRightRadius = bottomRightRadius;
    if (isLeft) {
      if (mTopLeftRadius.y > startPoint) {
        mTopLeftRadius = Radius.elliptical(startPoint, mTopLeftRadius.y);
      } else if ((size.height - mTopRightRadius.y) < endPoint) {
        mBottomLeftRadius =
            Radius.elliptical(size.height - endPoint, mTopRightRadius.y);
      }
    } else {
      if (mTopRightRadius.y > startPoint) {
        mTopRightRadius = Radius.elliptical(startPoint, mTopRightRadius.y);
      } else if ((size.height - mBottomRightRadius.y) < endPoint) {
        mBottomRightRadius =
            Radius.elliptical(size.height - endPoint, mBottomRightRadius.y);
      }
    }
    path2.addRRect(RRect.fromRectAndCorners(
        Rect.fromLTWH(leftX, 0, (size.width - arrowHeight), size.height),
        topLeft: mTopLeftRadius,
        topRight: mTopRightRadius,
        bottomLeft: mBottomLeftRadius,
        bottomRight: mBottomRightRadius));
    //合并
    path.addPath(path2, const Offset(0, 0));
  }

  _paintTopAndBottom(Size size, Path path, Path path2, double arrowPointY,
      double arrowBottomY, double topY, bool isTop) {
    double startPoint = 0;
    if (size.width > arrowWidth) {
      switch (arrowPositionBased) {
        case ArrowPositionBasedType.start:
          startPoint = arrowPosition - arrowWidth / 2.0;
          break;
        case ArrowPositionBasedType.center:
          startPoint = size.width / 2 + arrowPosition - arrowWidth / 2.0;
          break;
        case ArrowPositionBasedType.end:
          startPoint = size.width - arrowPosition - arrowWidth / 2.0;
          break;
      }
    }

    var endPoint = startPoint + arrowWidth;
    var arrowPoint = startPoint + arrowWidth / 2;
    if (endPoint < arrowWidth / 2) {
      endPoint = arrowWidth / 2;
    }
    if (startPoint > (size.width - arrowWidth / 2)) {
      startPoint = (size.width - arrowWidth / 2);
    }

    if (startPoint < 0) {
      startPoint = 0;
    }
    if (endPoint > size.width) {
      endPoint = size.width;
    }

    path.moveTo(startPoint, arrowBottomY);
    path.lineTo(endPoint, arrowBottomY);
    path.lineTo(arrowPoint, arrowPointY);
    path.close();

    var mTopLeftRadius = topLeftRadius;
    var mTopRightRadius = topRightRadius;
    var mBottomLeftRadius = bottomLeftRadius;
    var mBottomRightRadius = bottomRightRadius;
    if (isTop) {
      if (mTopLeftRadius.x > startPoint) {
        mTopLeftRadius = Radius.elliptical(startPoint, mTopLeftRadius.x);
      } else if ((size.width - mTopRightRadius.x) < endPoint) {
        mTopRightRadius =
            Radius.elliptical(size.width - endPoint, mTopRightRadius.x);
      }
    } else {
      if (mBottomLeftRadius.x > startPoint) {
        mBottomLeftRadius = Radius.elliptical(startPoint, mBottomLeftRadius.x);
      } else if ((size.width - mBottomRightRadius.x) < endPoint) {
        mBottomRightRadius =
            Radius.elliptical(size.width - endPoint, mBottomRightRadius.x);
      }
    }

    path2.addRRect(RRect.fromRectAndCorners(
        Rect.fromLTWH(0, topY, size.width, size.height - arrowHeight),
        topLeft: mTopLeftRadius,
        topRight: mTopRightRadius,
        bottomLeft: mBottomLeftRadius,
        bottomRight: mBottomRightRadius));

    path.addPath(path2, const Offset(0, 0));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; // 不重新裁剪
  }
}
