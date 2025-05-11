import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/Department.dart';
import '../../models/Employee.dart';
import '../../models/Revizor.dart';
import '../../providers/AuditProvider.dart';
import '../../providers/BindingProvider.dart';
import '../../providers/DepartmentProvider.dart';
import '../../providers/EmployeeProvider.dart';
import '../../providers/RevizorProvider.dart';

class CreateAuditScreen extends StatefulWidget {
  @override
  _CreateAuditScreenState createState() => _CreateAuditScreenState();
}

class _CreateAuditScreenState extends State<CreateAuditScreen> {
  int? selectedDepartmentId;
  List<int> employeesForSelectedDepartment = [];
  int? selectedEmployeeId;
  int? selectedRevizorId;
  Revizor? selectedRevizor;
  Department? selectedDepartment;
  Employee? selectedEmployee;

  final TextEditingController _dateReceivedController = TextEditingController();
  final TextEditingController _ticketController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  DateTime? selectedDateReceived;
  bool _showViewFields = false;
  List<Map<String, String>> _viewFields = [];

  @override
  void initState() {
    super.initState();
    final bindingProvider = Provider.of<BindingProvider>(context, listen: false);
    bindingProvider.fetchBindings();
  }

  @override
  void dispose() {
    _dateReceivedController.dispose();
    _ticketController.dispose();
    _descriptionController.dispose();
    _purposeController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final departmentProvider = Provider.of<DepartmentProvider>(context);
    final bindingProvider = Provider.of<BindingProvider>(context);
    final revizorProvider = Provider.of<RevizorProvider>(context);
    final reportProvider = Provider.of<AuditProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Создание отчета')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, _dateReceivedController),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _dateReceivedController,
                            decoration: InputDecoration(
                              labelText: 'Дата проверки',
                              labelStyle: TextStyle(fontSize: 14),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Выберите филиал',
                          labelStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none,
                        ),
                        value: selectedDepartmentId,
                        items: departmentProvider.departments
                            .map((department) => DropdownMenuItem(
                          value: department.id,
                          child: Text(department.name),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDepartmentId = value;
                            selectedDepartment = departmentProvider.departments
                                .firstWhere((dept) => dept.id == value);
                            selectedEmployeeId = null;
                            employeesForSelectedDepartment = bindingProvider
                                .bindings
                                .where((binding) =>
                            binding.department?.id == selectedDepartmentId)
                                .map((binding) => binding.employee?.id ?? 0)
                                .toList();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Выберите сотрудника',
                          labelStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none,
                        ),
                        value: selectedEmployeeId,
                        items: employeesForSelectedDepartment.isNotEmpty
                            ? employeesForSelectedDepartment.map((employeeId) {
                          final employee = bindingProvider.bindings
                              .firstWhere((binding) =>
                          binding.employee?.id == employeeId)
                              .employee;
                          return DropdownMenuItem<int>(
                            value: employee?.id,
                            child: Text(employee?.name ?? 'Не найдено'),
                          );
                        }).toList()
                            : [
                          DropdownMenuItem<int>(
                            value: null,
                            child: Text('Нет сотрудников'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedEmployeeId = value;
                            selectedEmployee = bindingProvider.bindings
                                .firstWhere((binding) =>
                            binding.employee?.id == value)
                                .employee;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<int>(
                        hint: Text('Ревизор', style: TextStyle(fontSize: 14)),
                        value: selectedRevizorId,
                        onChanged: (newId) {
                          setState(() {
                            selectedRevizorId = newId;
                            selectedRevizor = revizorProvider.revizors
                                .firstWhere((revizor) => revizor.id == newId);
                          });
                        },
                        items: revizorProvider.revizors.map((revizor) {
                          return DropdownMenuItem(
                            value: revizor.id,
                            child: Text(revizor.name,
                                style: TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _ticketController,
                        decoration: InputDecoration(
                          labelText: 'Залоговый билет',
                          labelStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Описание',
                          labelStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _purposeController,
                        decoration: InputDecoration(
                          labelText: 'Замечание',
                          labelStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _commentsController,
                        decoration: InputDecoration(
                          labelText: 'Комментарии',
                          labelStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedDepartmentId != null &&
                          selectedEmployeeId != null &&
                          selectedRevizorId != null) {
                        reportProvider
                            .createAudit(
                          departmentId: selectedDepartmentId!,
                          employeeId: selectedEmployeeId!,
                          revizorId: selectedRevizorId!,
                          dateReceived: _dateReceivedController.text,
                          ticket: _ticketController.text,
                          description: _descriptionController.text,
                          purpose: _purposeController.text,
                          comments: _commentsController.text,
                        )
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Отчет успешно создан!')),
                          );
                          setState(() {
                            selectedDepartmentId = null;
                            selectedEmployeeId = null;
                            selectedRevizorId = null;
                            _dateReceivedController.clear();
                            _ticketController.clear();
                            _descriptionController.clear();
                            _purposeController.clear();
                            _commentsController.clear();
                            _viewFields.clear();
                            _showViewFields = false;
                          });
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                Text('Ошибка при создании отчета: $error')),
                          );
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Выберите филиал, сотрудника и ревизора!')),
                        );
                      }
                    },
                    child: Text('Создать отчет'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showViewFields = !_showViewFields;
                        if (_showViewFields) {
                          _viewFields = [{
                            'Филиал': selectedDepartment?.name ?? 'Не выбран',
                            'Дата проверки': _dateReceivedController.text,
                            'Сотрудник': selectedEmployee?.name ?? 'Не выбран',
                            'Ревизор': selectedRevizor?.name ?? 'Не выбран',
                            'Зал. билет': _ticketController.text,
                            'Описание': _descriptionController.text,
                            'Замечание': _purposeController.text,
                            'Комментарии': _commentsController.text,
                          }];
                        }
                      });
                    },
                    child: Text('Просмотр'),
                  ),
                ),
              ],
            ),
            if (_showViewFields && _viewFields.isNotEmpty)
              ..._viewFields.map((field) => _buildViewRow(field)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildViewRow(Map<String, String> field) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: field.entries.map((entry) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          entry.value,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(field),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, String> field) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Удалить запись?'),
          content: Text('Вы уверены, что хотите удалить эту запись?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _viewFields.remove(field);
                  if (_viewFields.isEmpty) {
                    _showViewFields = false;
                  }
                });
                Navigator.pop(context);
              },
              child: Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        selectedDateReceived = selectedDate;
        controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }
}