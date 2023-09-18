import 'home.dart';
import 'package:flutter/widgets.dart';

class SectionViewRoute {
  static const String initialRoute = "/";
  static final Map<String, WidgetBuilder> routes = {
    "/": (context) => const Stack(
          children: [
            // TestPositionConditionPage(),
            HomePage(),
            // SimplePage(),
            // TestPageConditionPage(),
            // TestComplexConditionPage(),
            // TestNestGuidancePage(),
          ],
        ),
  };
}
