import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/Employee.dart';
import '../models/Department.dart';
import '../models/Revizor.dart';
import '../providers/DepartmentProvider.dart';
import '../providers/EmployeeProvider.dart';
import '../providers/AuditProvider.dart';
import '../providers/RevizorProvider.dart';

class CreateAuditScreen extends StatefulWidget {
  @override
  _CreateAuditScreenState createState() => _CreateAuditScreenState();
}

class _CreateAuditScreenState extends State<CreateAuditScreen> {
  int? selectedDepartmentId;
  Department? selectedDepartment;
  int? selectedEmployeeId;
  int? selectedRevizorId;
  Employee? selectedEmployee;
  Revizor? selectedRevizor;
  DateTime? selectedDateReceived;

  // Контроллеры для текстовых полей
  final TextEditingController _dateReceivedController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _ticketController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  // Состояние для отображения полей просмотра
  bool _showViewFields = false;

  // Список строк для отображения
  final List<Map<String, String>> _viewFields = [];

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Начальная дата
      firstDate: DateTime(2000), // Первая доступная дата
      lastDate: DateTime(2101), // Последняя доступная дата
    );

    if (selectedDate != null) {
      setState(() {
        selectedDateReceived = selectedDate; // Сохраняем дату в переменную
        controller.text = DateFormat('yyyy-MM-dd').format(selectedDate); // Обновляем текст в поле
      });
    }
  }

  @override
  void dispose() {
    // Очистка контроллеров при уничтожении виджета
    _dateReceivedController.dispose();
    _ticketController.dispose();
    _purposeController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final departmentProvider = Provider.of<DepartmentProvider>(context);
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final revizorProvider = Provider.of<RevizorProvider>(context);
    final reportProvider = Provider.of<AuditProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Создать отчет'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Первая строка с выпадающими списками и текстовыми полями
            Row(
              children: [
                // Поле выбора даты проверки
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, _dateReceivedController),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AbsorbPointer(
                          // Отключаем возможность редактирования текста
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
                SizedBox(width: 10), // Отступ между элементами

                // Выпадающее окно для выбора филиала
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<int>(
                        hint: Text('Филиал', style: TextStyle(fontSize: 14)),
                        value: selectedDepartmentId,
                        onChanged: (newId) {
                          setState(() {
                            selectedDepartmentId = newId;
                            selectedDepartment = departmentProvider.departments
                                .firstWhere((dept) => dept.id == newId);
                          });
                        },
                        items: departmentProvider.departments.map((dept) {
                          return DropdownMenuItem(
                            value: dept.id,
                            child:
                                Text(dept.name, style: TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Отступ между элементами

                // Поле "Залоговый билет"
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
                SizedBox(width: 10), // Отступ между элементами

                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<int>(
                        hint: Text('Сотрудник', style: TextStyle(fontSize: 14)),
                        value: selectedEmployeeId,
                        onChanged: (newId) {
                          setState(() {
                            selectedEmployeeId = newId;
                            selectedEmployee = employeeProvider.employees
                                .firstWhere((employee) => employee.id == newId);
                          });
                        },
                        items: employeeProvider.employees.map((employee) {
                          return DropdownMenuItem(
                            value: employee.id,
                            child: Text(employee.name,
                                style: TextStyle(fontSize: 14)),
                          );
                        }).toList(),
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
                SizedBox(width: 10),
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
                SizedBox(width: 10), // Отступ между элементами

                // Текстовое поле для "Комментарии"
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
            SizedBox(height: 20), // Отступ между элементами

            // Кнопки "Создать отчет" и "Просмотр" в один ряд
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedDepartmentId != null &&
                          selectedEmployeeId != null) {
                        reportProvider
                            .createAudit(
                          departmentId: selectedDepartmentId!,
                          employeeId: selectedEmployeeId!,
                          revizorId: selectedRevizorId!,
                          dateReceived: _dateReceivedController.text,
                          ticket: _ticketController.text,
                          purpose: _purposeController.text,
                          comments: _commentsController.text,
                        )
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Отчет успешно создан!')),
                          );
                          // Очищаем поля
                          setState(() {
                            selectedDepartmentId = null;
                            selectedEmployeeId = null;
                            _dateReceivedController.clear();
                            _purposeController.clear();
                            _commentsController.clear();
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
                                  'Выберите филиал, и сотрудника!')),
                        );
                      }
                    },
                    child: Text('Создать отчет'),
                  ),
                ),
                SizedBox(width: 10), // Отступ между кнопками
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showViewFields =
                            !_showViewFields; // Переключаем отображение полей
                        if (_showViewFields) {
                          // Добавляем текущие значения в список для отображения
                          _viewFields.add({
                            'Филиал': selectedDepartment?.name ?? 'Не выбран',
                            'Дата проверки': _dateReceivedController.text,
                            'Сотрудник': selectedEmployee?.name ?? 'Не выбран',
                            'Ревизор': selectedRevizor?.name ?? 'Не выбран',
                            'Залоговый билет': _ticketController.text,
                            'Назначение': _purposeController.text,
                            'Комментарии': _commentsController.text,
                          });
                        }
                      });
                    },
                    child: Text('Просмотр'),
                  ),
                ),
              ],
            ),

            // Отображение полей просмотра
            if (_showViewFields)
              Column(
                children: _viewFields.map((field) {
                  return _buildViewRow(field);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  // Метод для создания строки просмотра
  Widget _buildViewRow(Map<String, String> field) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          // Поля в строке
          Expanded(
            child: Row(
              children: field.entries.map((entry) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                  ),
                );
              }).toList(),
            ),
          ),

          // Иконка "Удалить"
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _showDeleteDialog(
                  field); // Показываем диалоговое окно для подтверждения удаления
            },
          ),
        ],
      ),
    );
  }

  // Метод для отображения диалогового окна удаления
  void _showDeleteDialog(Map<String, String> field) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Удалить запись?'),
          content: Text('Вы уверены, что хотите удалить эту запись?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Закрыть диалоговое окно
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _viewFields.remove(field); // Удаляем строку из списка
                });
                Navigator.pop(context); // Закрыть диалоговое окно
              },
              child: Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
