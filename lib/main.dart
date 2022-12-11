import 'package:flutter/material.dart';
import 'package:testing_app/test_feature/ui/test_feature.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      title: 'Location App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TestFeature(),
    );
  }
}
