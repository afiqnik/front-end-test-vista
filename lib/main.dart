import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/company_provider.dart';
import 'screens/company_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CompanyProvider(),
      child: const JipApp(),
    ),
  );
}

class JipApp extends StatelessWidget {
  const JipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JIP Company Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CompanyListScreen(),
    );
  }
}
