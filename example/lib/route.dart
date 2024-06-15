import 'simple.dart';
import 'test_bottom_sheet.dart';
import 'test_page_condition.dart';
import 'test_position_condition.dart';

import 'home.dart';
import 'package:flutter/widgets.dart';

import 'test_complex_condition.dart';
import 'test_nest_guidance.dart';
import 'test_tab_guidance.dart';

class SectionViewRoute {
  static const String initialRoute = "/";
  static final Map<String, WidgetBuilder> routes = {
    "/": (context) => const Stack(
          children: [HomePage()],
        ),
    "/TestTabGuidance": (context) => const TestTabGuidance(),
    "/TestPositionConditionPage": (context) =>
        const TestPositionConditionPage(),
    "/SimplePage": (context) => const SimplePage(),
    "/TestPageConditionPage": (context) => const TestPageConditionPage(),
    "/TestComplexConditionPage": (context) => const TestComplexConditionPage(),
    "/TestNestGuidancePage": (context) => const TestNestGuidancePage(),
    "/TestBottomSheetPage": (context) => const TestBottomSheetPage()
  };
}
