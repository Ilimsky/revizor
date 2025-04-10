import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/Department.dart';
import '../providers/DepartmentProvider.dart';
import '../providers/AuditProvider.dart';

class CreateAuditScreen extends StatefulWidget {
  @override
  _CreateAuditScreenState createState() => _CreateAuditScreenState();
}

class _CreateAuditScreenState extends State<CreateAuditScreen> {
  int? selectedDepartmentId;
  Department? selectedDepartment;
  int? selectedJobId;
  int? selectedEmployeeId;
  int? selectedAccountId;
  DateTime? selectedDateReceived;
  DateTime? selectedDateApproved;
  DateTime? selectedDateCreated;

  // Контроллеры для текстовых полей
  final TextEditingController _dateReceivedController = TextEditingController();
  final TextEditingController _amountIssuedController = TextEditingController();
  final TextEditingController _dateApprovedController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _recognizedAmountController =
      TextEditingController();
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
    _amountIssuedController.dispose();
    _dateApprovedController.dispose();
    _purposeController.dispose();
    _recognizedAmountController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final departmentProvider = Provider.of<DepartmentProvider>(context);
    final auditProvider = Provider.of<AuditProvider>(context);

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

                // Текстовое поле для "Дата получения д/с"
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

                // Текстовое поле для "Выданная сумма"
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _amountIssuedController,
                        decoration: InputDecoration(
                          labelText: 'Замечание/косяк',
                          labelStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 14),
                        keyboardType: TextInputType.number, // Для ввода чисел
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Отступ между элементами

                // Выпадающее окно для выбора должности
              ],
            ),
            SizedBox(height: 20), // Отступ между элементами

            // Вторая строка с выпадающими списками и текстовыми полями
            Row(
              children: [
                // Выпадающее окно для выбора сотрудника
                SizedBox(width: 10), // Отступ между элементами

                // Текстовое поле для "Назначение"
                // Текстовое поле для "Признанная сумма затрат по а/о"
                // Выпадающее окно для выбора счета
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
                      if (selectedDepartmentId != null) {
                        auditProvider
                            .createAudit(
                          departmentId: selectedDepartmentId!,
                          dateReceived: _dateReceivedController.text,
                          amountIssued: _amountIssuedController.text,
                          dateApproved: _dateApprovedController.text,
                          purpose: _purposeController.text,
                          recognizedAmount: _recognizedAmountController.text,
                          comments: _commentsController.text,
                        )
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Отчет успешно создан!')),
                          );
                          // Очищаем поля
                          setState(() {
                            selectedDepartmentId = null;
                            selectedJobId = null;
                            selectedEmployeeId = null;
                            selectedAccountId = null;
                            _dateReceivedController.clear();
                            _amountIssuedController.clear();
                            _dateApprovedController.clear();
                            _purposeController.clear();
                            _recognizedAmountController.clear();
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
                                  'Выберите филиал')),
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
                            'Замечание/косяк': _dateReceivedController.text,
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
