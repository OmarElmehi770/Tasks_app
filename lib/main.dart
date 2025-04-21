import 'package:flutter/material.dart';
import 'package:tasks_app/sql_management/sql_helper.dart';

import 'presentation/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SqlHelper.getDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TasksScreen(),
    );
  }
}

