import 'package:flutter/material.dart';
import 'package:frontend/providers/BindingProvider.dart';
import 'package:frontend/providers/DepartmentProvider.dart';
import 'package:frontend/providers/EmployeeProvider.dart';
import 'package:frontend/providers/RevizorProvider.dart';
import 'package:frontend/screens/create_audit_screen/create_audit_screen.dart';
import 'package:frontend/screens/audit_screen/audits_screen.dart';
import 'package:provider/provider.dart';

import 'screens/reference_screen/reference_screen.dart';
import 'providers/AuditProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BindingProvider()),
        ChangeNotifierProvider(create: (_) => DepartmentProvider()),
        ChangeNotifierProvider(create: (_) => AuditProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => RevizorProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Азимыч',
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
    ReferenceScreen(), // Справочник
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Единая система для ревизоров')),
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