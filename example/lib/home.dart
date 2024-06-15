import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guidance Demo"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/TestTabGuidance");
                },
                child: const Text("TestTabGuidance")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/TestPositionConditionPage");
                },
                child: const Text("TestPositionConditionPage")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/SimplePage");
                },
                child: const Text("SimplePage")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/TestPageConditionPage");
                },
                child: const Text("TestPageConditionPage")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/TestComplexConditionPage");
                },
                child: const Text("TestComplexConditionPage")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/TestNestGuidancePage");
                },
                child: const Text("TestNestGuidancePage")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/TestBottomSheetPage");
                },
                child: const Text("TestBottomSheetPage")),
            const Padding(padding: EdgeInsets.all(20.0))
          ],
        ),
      ),
    );
  }
}
