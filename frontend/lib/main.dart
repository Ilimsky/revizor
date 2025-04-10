import 'package:flutter/material.dart';
import 'package:frontend/providers/DepartmentProvider.dart';
import 'package:frontend/screens/CreateAuditScreen.dart';
import 'package:frontend/screens/report_screen/audits_screen.dart';
import 'package:provider/provider.dart';

import 'screens/ReferenceScreen.dart';
import 'providers/AuditProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DepartmentProvider()),
        ChangeNotifierProvider(create: (_) => AuditProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Авансовые отчеты',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    AuditsScreen(), // Список отчетов
    CreateAuditScreen(), // Создание отчетов
    ReferenceScreen(), // Справочник (филиалы)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Проверки')),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Список отчетов'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Создание отчетов'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Справочник'),
        ],
      ),
    );
  }
}