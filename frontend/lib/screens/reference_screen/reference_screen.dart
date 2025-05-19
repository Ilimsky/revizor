import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/reference_screen/bindings_tab.dart';
import 'package:frontend/screens/reference_screen/revizors_tab.dart';
import 'package:provider/provider.dart';

import '../../providers/DepartmentProvider.dart';
import '../../providers/EmployeeProvider.dart';
import '../../providers/RevizorProvider.dart';
import 'departments_tab.dart';
import 'employees_tab.dart';

class ReferenceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Количество вкладок
      child: Scaffold(
        appBar: AppBar(
          title: Text('Справочник'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Привязка'),
              Tab(text: 'Филиалы'),
              Tab(text: 'Сотрудники'),
              Tab(text: 'Ревизоры'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BindingsTab(), // Вкладка для привязки
            DepartmentsTab(), // Вкладка для филиалов
            EmployeesTab(), // Вкладка для сотрудников
            RevizorsTab(), // Вкладка для ревизоров
          ],
        ),
      ),
    );
  }
}

// // Вкладка для филиалов
// // class DepartmentsTab extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final departmentProvider = Provider.of<DepartmentProvider>(context);
// //
// //     return Column(
// //       children: [
// //         Padding(
// //           padding: EdgeInsets.all(8.0),
// //           child: Row(
// //             children: [
// //               IconButton(
// //                 icon: Icon(Icons.add),
// //                 onPressed: () {
// //                   final textController = TextEditingController();
// //                   showDialog(
// //                     context: context,
// //                     builder: (context) => AlertDialog(
// //                       title: Text('Добавить филиал'),
// //                       content: TextField(controller: textController),
// //                       actions: [
// //                         TextButton(
// //                           onPressed: () {
// //                             if (textController.text.isNotEmpty) {
// //                               departmentProvider.createDepartment(textController.text);
// //                               Navigator.pop(context);
// //                             }
// //                           },
// //                           child: Text('Добавить'),
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ],
// //           ),
// //         ),
// //         Expanded(
// //           child: departmentProvider.isLoading
// //               ? Center(child: CircularProgressIndicator())
// //               : ListView.builder(
// //             itemCount: departmentProvider.departments.length,
// //             itemBuilder: (context, index) {
// //               final dept = departmentProvider.departments[index];
// //               return ListTile(
// //                 title: Text(dept.name),
// //                 trailing: Row(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     IconButton(
// //                       icon: Icon(Icons.edit),
// //                       onPressed: () {
// //                         final textController = TextEditingController(text: dept.name);
// //                         showDialog(
// //                           context: context,
// //                           builder: (context) => AlertDialog(
// //                             title: Text('Редактировать филиал'),
// //                             content: TextField(controller: textController),
// //                             actions: [
// //                               TextButton(
// //                                 onPressed: () {
// //                                   if (textController.text.isNotEmpty) {
// //                                     departmentProvider.updateDepartment(dept.id, textController.text);
// //                                     Navigator.pop(context);
// //                                   }
// //                                 },
// //                                 child: Text('Сохранить'),
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     IconButton(
// //                       icon: Icon(Icons.delete),
// //                       onPressed: () => _showDeleteDialog(context, dept.id, departmentProvider),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   // Метод для отображения диалога удаления филиала
// //   void _showDeleteDialog(BuildContext context, int departmentId, DepartmentProvider departmentProvider) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text('Удалить филиал'),
// //         content: Text('Вы уверены, что хотите удалить этот филиал?'),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context); // Закрыть диалог
// //             },
// //             child: Text('Отмена'),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               departmentProvider.deleteDepartment(departmentId); // Удалить филиал
// //               Navigator.pop(context); // Закрыть диалог
// //             },
// //             child: Text('Удалить', style: TextStyle(color: Colors.red)),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// // Вкладка для сотрудников
// class EmployeesTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final employeeProvider = Provider.of<EmployeeProvider>(context);
//
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.add),
//                 onPressed: () {
//                   final textController = TextEditingController();
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: Text('Добавить сотрудника'),
//                       content: TextField(controller: textController),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             if (textController.text.isNotEmpty) {
//                               employeeProvider.createEmployee(textController.text);
//                               Navigator.pop(context);
//                             }
//                           },
//                           child: Text('Добавить'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: employeeProvider.isLoading
//               ? Center(child: CircularProgressIndicator())
//               : ListView.builder(
//             itemCount: employeeProvider.employees.length,
//             itemBuilder: (context, index) {
//               final employee = employeeProvider.employees[index];
//               return ListTile(
//                 title: Text(employee.name),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit),
//                       onPressed: () {
//                         final textController = TextEditingController(text: employee.name);
//                         showDialog(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: Text('Редактировать сотрудника'),
//                             content: TextField(controller: textController),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   if (textController.text.isNotEmpty) {
//                                     employeeProvider.updateEmployee(employee.id, textController.text);
//                                     Navigator.pop(context);
//                                   }
//                                 },
//                                 child: Text('Сохранить'),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () => _showDeleteDialog(context, employee.id, employeeProvider),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Метод для отображения диалога удаления сотрудника
//   void _showDeleteDialog(BuildContext context, int employeeId, EmployeeProvider employeeProvider) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Удалить сотрудника'),
//         content: Text('Вы уверены, что хотите удалить этого сотрудника?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Закрыть диалог
//             },
//             child: Text('Отмена'),
//           ),
//           TextButton(
//             onPressed: () {
//               employeeProvider.deleteEmployee(employeeId); // Удалить должность
//               Navigator.pop(context); // Закрыть диалог
//             },
//             child: Text('Удалить', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Вкладка для сотрудников
// class RevizorsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final revizorProvider = Provider.of<RevizorProvider>(context);
//
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.add),
//                 onPressed: () {
//                   final textController = TextEditingController();
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: Text('Добавить сотрудника'),
//                       content: TextField(controller: textController),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             if (textController.text.isNotEmpty) {
//                               revizorProvider.createRevizor(textController.text);
//                               Navigator.pop(context);
//                             }
//                           },
//                           child: Text('Добавить'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: revizorProvider.isLoading
//               ? Center(child: CircularProgressIndicator())
//               : ListView.builder(
//             itemCount: revizorProvider.revizors.length,
//             itemBuilder: (context, index) {
//               final revizor = revizorProvider.revizors[index];
//               return ListTile(
//                 title: Text(revizor.name),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit),
//                       onPressed: () {
//                         final textController = TextEditingController(text: revizor.name);
//                         showDialog(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: Text('Редактировать сотрудника'),
//                             content: TextField(controller: textController),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   if (textController.text.isNotEmpty) {
//                                     revizorProvider.updateRevizor(revizor.id, textController.text);
//                                     Navigator.pop(context);
//                                   }
//                                 },
//                                 child: Text('Сохранить'),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () => _showDeleteDialog(context, revizor.id, revizorProvider),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Метод для отображения диалога удаления сотрудника
//   void _showDeleteDialog(BuildContext context, int revizorId, RevizorProvider revizorProvider) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Удалить сотрудника'),
//         content: Text('Вы уверены, что хотите удалить этого сотрудника?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Закрыть диалог
//             },
//             child: Text('Отмена'),
//           ),
//           TextButton(
//             onPressed: () {
//               revizorProvider.deleteRevizor(revizorId); // Удалить должность
//               Navigator.pop(context); // Закрыть диалог
//             },
//             child: Text('Удалить', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }