import 'package:flutter/material.dart';

enum ArrowPositionBasedType {
  start,
  center,
  end,
}

class BubbleWidget extends StatelessWidget {
  final BubbleDirection direction; // 箭头方向
  final Widget child;

  const BubbleWidget(
      {Key? key,
      this.direction = BubbleDirection.left,
      this.arrowWidth = 10.0,
      this.arrowHeight = 10.0,
      this.arrowPosition = 20.0,
      this.arrowPositionBased = ArrowPositionBasedType.start,
      this.bkColor = Colors.white,
      this.radius = const Radius.circular(4.0),
      required this.child})
      : super(key: key);
  final double arrowWidth;
  final double arrowHeight;

  final double arrowPosition;
  final ArrowPositionBasedType arrowPositionBased;

  final Color bkColor;
  final Radius radius;

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

    return ClipPath(
      clipper: _BubbleClipper(
          direction: direction,
          radius: radius,
          arrowWidth: arrowWidth,
          arrowHeight: arrowHeight,
          arrowPosition: arrowPosition,
          arrowPositionBased: arrowPositionBased),
      child: Container(
          constraints: (const BoxConstraints())
              .copyWith(minHeight: _minHeight, minWidth: _minWidth),
          color: bkColor,
          child: Padding(
            padding: EdgeInsets.only(
                left: paddingLeft,
                right: paddingRight,
                top: paddingTop,
                bottom: paddingBottom),
            child: child,
          )),
    );
  }
}

// 方向
enum BubbleDirection { left, right, top, bottom }

class _BubbleClipper extends CustomClipper<Path> {
  final BubbleDirection direction;
  final double arrowWidth;
  final double arrowHeight;
  final Radius radius;
  final double arrowPosition;
  final ArrowPositionBasedType arrowPositionBased;
  _BubbleClipper(
      {required this.direction,
      required this.radius,
      required this.arrowWidth,
      required this.arrowHeight,
      required this.arrowPosition,
      required this.arrowPositionBased});

  @override // 获取裁剪
  Path getClip(Size size) {
    final path = Path();
    final path2 = Path();

    if (direction == BubbleDirection.left) {
      //绘制三角形
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

      if (startPoint < 0) {
        startPoint = 0;
      } else if ((startPoint + arrowWidth) > size.height) {
        startPoint = size.height - arrowWidth;
      }

      path.moveTo(arrowHeight, startPoint);
      path.lineTo(arrowHeight, startPoint + arrowWidth);
      path.lineTo(0, startPoint + arrowWidth / 2);
      path.close();
      //绘制矩形
      path2.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(
              arrowHeight, 0, (size.width - arrowHeight), size.height),
          radius));
      //合并
      path.addPath(path2, const Offset(0, 0));
    } else if (direction == BubbleDirection.right) {
      //绘制三角形
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

      if (startPoint < 0) {
        startPoint = 0;
      } else if ((startPoint + arrowWidth) > size.height) {
        startPoint = size.height - arrowWidth;
      }

      path.moveTo(size.width - arrowHeight, startPoint);
      path.lineTo(size.width - arrowHeight, startPoint + arrowWidth);
      path.lineTo(size.width, startPoint + arrowWidth / 2);
      path.close();

      path2.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, (size.width - arrowHeight), size.height),
          radius));

      path.addPath(path2, const Offset(0, 0));
    } else if (direction == BubbleDirection.top) {
      //绘制三角形
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

      if (startPoint < 0) {
        startPoint = 0;
      } else if ((startPoint + arrowWidth) > size.width) {
        startPoint = size.width - arrowWidth;
      }

      path.moveTo(startPoint, arrowHeight);
      path.lineTo(startPoint + arrowWidth, arrowHeight);
      path.lineTo(startPoint + arrowWidth / 2, 0);
      path.close();

      path2.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, arrowHeight, size.width, size.height - arrowHeight),
          radius));

      path.addPath(path2, const Offset(0, 0));
    } else {
      //绘制三角形
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

      if (startPoint < 0) {
        startPoint = 0;
      } else if ((startPoint + arrowWidth) > size.width) {
        startPoint = size.width - arrowWidth;
      }

      path.moveTo(startPoint, size.height - arrowHeight);
      path.lineTo(startPoint + arrowWidth, size.height - arrowHeight);
      path.lineTo(startPoint + arrowWidth / 2, size.height);
      path.close();

      path2.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height - arrowHeight), radius));

      path.addPath(path2, const Offset(0, 0));
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; // 不重新裁剪
  }
}
