import 'home.dart';
import 'package:flutter/widgets.dart';

import 'simple.dart';
import 'test_appear_condition.dart';
import 'test_complex_condition.dart';
import 'test_nest_guidance.dart';
import 'test_page_condition.dart';
import 'test_position_condition.dart';

class SectionViewRoute {
  static const String initialRoute = "/";
  static final Map<String, WidgetBuilder> routes = {
    "/": (context) => Stack(
          children: const [
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
