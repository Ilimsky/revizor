import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Audit.dart';
import '../../models/Department.dart';
import '../../models/Employee.dart';
import '../../models/Revizor.dart';
import '../../providers/AuditProvider.dart';
import '../../providers/DepartmentProvider.dart';
import '../../providers/EmployeeProvider.dart';
import '../../providers/RevizorProvider.dart';

class AuditDialogs {
  static void showEditDialog({
    required BuildContext context,
    required Audit audit,
    required AuditProvider auditProvider,
    required DepartmentProvider departmentProvider,
    required EmployeeProvider employeeProvider,
    required RevizorProvider revizorProvider,
  }) {
    final currentDepartment = departmentProvider.departments.firstWhere(
          (d) => d.id == audit.departmentId,
      orElse: () => Department(id: 0, name: 'Неизвестно'),
    );

    final currentEmployee = employeeProvider.employees.firstWhere(
          (e) => e.id == audit.employeeId,
      orElse: () => Employee(id: 0, name: 'Неизвестно'),
    );

    final currentRevizor = revizorProvider.revizors.firstWhere(
          (r) => r.id == audit.revizorId,
      orElse: () => Revizor(id: 0, name: 'Неизвестно'),
    );

    final ticketController = TextEditingController(text: audit.ticket);
    final descriptionController = TextEditingController(text: audit.description);
    final purposeController = TextEditingController(text: audit.purpose);
    final commentsController = TextEditingController(text: audit.comments);

    Department? selectedDepartment = currentDepartment;
    Employee? selectedEmployee = currentEmployee;
    Revizor? selectedRevizor = currentRevizor;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Редактировать проверку'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<Department>(
                      value: selectedDepartment,
                      decoration: InputDecoration(labelText: 'Филиал'),
                      items: departmentProvider.departments.map((department) {
                        return DropdownMenuItem<Department>(
                          value: department,
                          child: Text(department.name),
                        );
                      }).toList(),
                      onChanged: (Department? newValue) {
                        setState(() {
                          selectedDepartment = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: ticketController,
                      decoration: InputDecoration(labelText: 'Залоговый билет'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Описание'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: purposeController,
                      decoration: InputDecoration(labelText: 'Замечание'),
                      maxLines: 3,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<Employee>(
                      value: selectedEmployee,
                      decoration: InputDecoration(labelText: 'Сотрудник'),
                      items: employeeProvider.employees.map((employee) {
                        return DropdownMenuItem<Employee>(
                          value: employee,
                          child: Text(employee.name),
                        );
                      }).toList(),
                      onChanged: (Employee? newValue) {
                        setState(() {
                          selectedEmployee = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<Revizor>(
                      value: selectedRevizor,
                      decoration: InputDecoration(labelText: 'Ревизор'),
                      items: revizorProvider.revizors.map((revizor) {
                        return DropdownMenuItem<Revizor>(
                          value: revizor,
                          child: Text(revizor.name),
                        );
                      }).toList(),
                      onChanged: (Revizor? newValue) {
                        setState(() {
                          selectedRevizor = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: commentsController,
                      decoration: InputDecoration(labelText: 'Комментарии'),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Отмена'),
                ),
                TextButton(
                  onPressed: () async {
                    if (selectedDepartment == null ||
                        selectedEmployee == null ||
                        selectedRevizor == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Пожалуйста, заполните все поля')),
                      );
                      return;
                    }

                    try {
                      await auditProvider.updateAudit(
                        audit.id,
                        audit.auditNumber,
                        selectedDepartment!.id,
                        ticket: ticketController.text,
                        description: descriptionController.text,
                        purpose: purposeController.text,
                        employeeId: selectedEmployee!.id,
                        revizorId: selectedRevizor!.id,
                        comments: commentsController.text,
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка при обновлении: $e')),
                      );
                    }
                  },
                  child: Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void showDeleteDialog({
    required BuildContext context,
    required int auditId,
    required AuditProvider auditProvider,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Удалить отчет'),
        content: Text('Вы уверены, что хотите удалить этот отчет?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              auditProvider.deleteAudit(auditId);
              Navigator.pop(context);
            },
            child: Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}