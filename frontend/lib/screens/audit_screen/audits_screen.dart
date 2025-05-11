import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import '../../models/Department.dart';
import '../../models/Employee.dart';
import '../../models/Revizor.dart';
import '../../providers/DepartmentProvider.dart';
import '../../providers/EmployeeProvider.dart';
import '../../models/Audit.dart';
import '../../providers/AuditProvider.dart';
import '../../providers/RevizorProvider.dart';

class AuditsScreen extends StatefulWidget {
  @override
  _AuditsScreenState createState() => _AuditsScreenState();
}

class _AuditsScreenState extends State<AuditsScreen> {
  int _sortColumnIndex = 0;
  bool _isAscending = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuditProvider>(context, listen: false).fetchAllAudits();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Audit> _filteredAudits(AuditProvider auditProvider) {
    if (_searchQuery.isEmpty) return auditProvider.audits;

    return auditProvider.audits.where((audit) {
      final department = Provider.of<DepartmentProvider>(context, listen: false)
          .departments
          .firstWhere((d) => d.id == audit.departmentId,
              orElse: () => Department(id: 0, name: ''));
      final employee = Provider.of<EmployeeProvider>(context, listen: false)
          .employees
          .firstWhere((e) => e.id == audit.employeeId,
              orElse: () => Employee(id: 0, name: ''));
      final revizor = Provider.of<RevizorProvider>(context, listen: false)
          .revizors
          .firstWhere((a) => a.id == audit.revizorId,
              orElse: () => Revizor(id: 0, name: ''));

      final dateReceivedStr = _dateFormat.format(audit.dateReceived);
      // final dateApprovedStr = audit.dateApproved != null
      //     ? _dateFormat.format(audit.dateApproved!)
      //     : '';

      final query = _searchQuery.toLowerCase();
      return audit.auditNumber.toString().contains(query) ||
          dateReceivedStr.toLowerCase().contains(query) ||
          // dateApprovedStr.toLowerCase().contains(query) ||
          // audit.amountIssued.toLowerCase().contains(query) ||
          // audit.recognizedAmount.toLowerCase().contains(query) ||
          audit.ticket.toLowerCase().contains(query) ||
          audit.purpose.toLowerCase().contains(query) ||
          audit.comments.toLowerCase().contains(query) ||
          department.name.toLowerCase().contains(query) ||
          // job.name.toLowerCase().contains(query) ||
          employee.name.toLowerCase().contains(query) ||
          revizor.name.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _printAudit(
      Audit audit, Department department, Employee employee) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                  level: 0,
                  child: pw.Text(
                      'Отчет №${audit.auditNumber}/${department.name}')),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Дата получения д/с'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(_dateFormat.format(audit.dateReceived)),
                      ),
                    ],
                  ),
                  // pw.TableRow(
                  //   children: [
                  //     pw.Padding(
                  //       padding: const pw.EdgeInsets.all(8.0),
                  //       child: pw.Text('Выданная сумма'),
                  //     ),
                  //     pw.Padding(
                  //       padding: const pw.EdgeInsets.all(8.0),
                  //       child: pw.Text(audit.amountIssued),
                  //     ),
                  //   ],
                  // ),
                  // pw.TableRow(
                  //   children: [
                  //     pw.Padding(
                  //       padding: const pw.EdgeInsets.all(8.0),
                  //       child: pw.Text('Дата утверждения а/о'),
                  //     ),
                  //     // pw.Padding(
                  //     //   padding: const pw.EdgeInsets.all(8.0),
                  //     //   child: pw.Text(audit.dateApproved != null
                  //     //       ? _dateFormat.format(audit.dateApproved!)
                  //     //       : 'Не утверждено'),
                  //     // ),
                  //   ],
                  // ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Сотрудник'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(employee.name),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  void _sort<T>(
    Comparable<T> Function(Audit r) getField,
    int columnIndex,
    bool ascending,
    AuditProvider provider,
  ) {
    provider.audits.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;
    });
  }

  void _showEditDialog(
      BuildContext context, Audit audit, AuditProvider auditProvider) {
    final departmentProvider = Provider.of<DepartmentProvider>(context, listen: false);
    final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    final revizorProvider = Provider.of<RevizorProvider>(context, listen: false);

    // Получаем текущие значения
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

    // Контроллеры для полей ввода
    final ticketController = TextEditingController(text: audit.ticket);
    final descriptionController = TextEditingController(text: audit.description);
    final purposeController = TextEditingController(text: audit.purpose);
    final commentsController = TextEditingController(text: audit.comments);

    // Переменные для выбранных значений
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
                        SnackBar(content: Text('Пожалуйста, заполните все поля')),
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

  void _showDeleteDialog(
      BuildContext context, int auditId, AuditProvider auditProvider) {
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

  @override
  Widget build(BuildContext context) {
    final auditProvider = Provider.of<AuditProvider>(context);
    final departmentProvider = Provider.of<DepartmentProvider>(context);
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final revizorProvider = Provider.of<RevizorProvider>(context);

    final filteredAudits = _filteredAudits(auditProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Список проверок'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Поиск',
                hintText: 'Введите текст для поиска',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: auditProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _isAscending,
                        headingRowHeight: 40,
                        dataRowMinHeight: 30,
                        dataRowMaxHeight: 40,
                        columnSpacing: 1,
                        columns: [
                          DataColumn(
                            label: Container(
                              width: 70,
                              child: Text(
                                'Дата проверки',
                                style: TextStyle(fontSize: 10),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onSort: (i, asc) => _sort<DateTime>(
                                (r) => r.dateReceived, i, asc, auditProvider),
                          ),
                          // DataColumn(
                          //   label: Container(
                          //     width: 90,
                          //     child: Text(
                          //       'Выданная сумма',
                          //       style: TextStyle(fontSize: 10),
                          //       softWrap: true,
                          //       overflow: TextOverflow.visible,
                          //       maxLines: 2,
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          //   onSort: (i, asc) =>
                          //       _sort<String>((r) => r.amountIssued, i, asc, auditProvider),
                          // ),
                          // DataColumn(
                          //   label: Container(
                          //     width: 70,
                          //     child: Text(
                          //       'Дата утверждения а/о',
                          //       style: TextStyle(fontSize: 10),
                          //       softWrap: true,
                          //       overflow: TextOverflow.visible,
                          //       maxLines: 2,
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          //   onSort: (i, asc) => _sort<DateTime?>(
                          //       (r) => r.dateApproved, i, asc, auditProvider),
                          // ),
                          // DataColumn(
                          //   label: Container(
                          //     width: 100,
                          //     child: Text(
                          //       'Должность',
                          //       style: TextStyle(fontSize: 10),
                          //       softWrap: true,
                          //       overflow: TextOverflow.visible,
                          //       maxLines: 1,
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          //   onSort: (i, asc) => _sort<String>(
                          //         (r) => jobProvider.jobs
                          //         .firstWhere((j) => j.id == r.jobId, orElse: () => Job(id: 0, name: 'Неизвестно'))
                          //         .name,
                          //     i,
                          //     asc,
                          //     auditProvider,
                          //   ),
                          // ),
                          DataColumn(
                            label: Container(
                              width: 200,
                              child: Text(
                                'Залоговый билет',
                                style: TextStyle(fontSize: 10),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onSort: (i, asc) => _sort<String>(
                                (r) => r.ticket, i, asc, auditProvider),
                          ),
                          DataColumn(
                            label: Container(
                              width: 200,
                              child: Text(
                                'Описание',
                                style: TextStyle(fontSize: 10),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onSort: (i, asc) => _sort<String>(
                                    (r) => r.description, i, asc, auditProvider),
                          ),
                          DataColumn(
                            label: Container(
                              width: 200,
                              child: Text(
                                'Замечание',
                                style: TextStyle(fontSize: 10),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onSort: (i, asc) => _sort<String>(
                                (r) => r.purpose, i, asc, auditProvider),
                          ),
                          DataColumn(
                            label: Container(
                              width: 120,
                              child: Text(
                                'Сотрудник',
                                style: TextStyle(fontSize: 10),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onSort: (i, asc) => _sort<String>(
                              (r) => employeeProvider.employees
                                  .firstWhere((e) => e.id == r.employeeId,
                                      orElse: () =>
                                          Employee(id: 0, name: 'Неизвестно'))
                                  .name,
                              i,
                              asc,
                              auditProvider,
                            ),
                          ),
                          // DataColumn(
                          //   label: Container(
                          //     width: 90,
                          //     child: Text(
                          //       'Признанная сумма',
                          //       style: TextStyle(fontSize: 10),
                          //       softWrap: true,
                          //       overflow: TextOverflow.visible,
                          //       maxLines: 2,
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          //   onSort: (i, asc) => _sort<String>(
                          //       (r) => r.recognizedAmount,
                          //       i,
                          //       asc,
                          //       auditProvider),
                          // ),
                          DataColumn(
                            label: Container(
                              width: 60,
                              child: Text(
                                'Ревизор',
                                style: TextStyle(fontSize: 10),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onSort: (i, asc) => _sort<String>(
                              (r) => revizorProvider.revizors
                                  .firstWhere((a) => a.id == r.revizorId,
                                      orElse: () =>
                                          Revizor(id: 0, name: 'Неизвестно'))
                                  .name,
                              i,
                              asc,
                              auditProvider,
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: 200,
                              child: Text(
                                'Комментарии',
                                style: TextStyle(fontSize: 10),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onSort: (i, asc) => _sort<String>(
                                (r) => r.comments, i, asc, auditProvider),
                          ),
                          DataColumn(
                            label: Container(
                              width: 60,
                              child: Text(
                                'Действия',
                                style: TextStyle(fontSize: 10),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                        rows: filteredAudits.map((audit) {
                          final department =
                              departmentProvider.departments.firstWhere(
                            (d) => d.id == audit.departmentId,
                            orElse: () => Department(id: 0, name: 'Неизвестно'),
                          );
                          final employee =
                              employeeProvider.employees.firstWhere(
                            (e) => e.id == audit.employeeId,
                            orElse: () => Employee(id: 0, name: 'Неизвестно'),
                          );
                          final revizor = revizorProvider.revizors.firstWhere(
                            (a) => a.id == audit.revizorId,
                            orElse: () => Revizor(id: 0, name: 'Неизвестно'),
                          );

                          return DataRow(cells: [
                            DataCell(Container(
                              width: 80,
                              child: Text(
                                _dateFormat.format(audit.dateReceived),
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            )),
                            DataCell(Container(
                              width: 200,
                              child: Text(
                                '${department.name}/${audit.ticket}', // Добавляем номер филиала перед билетом
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            )),
                            DataCell(Container(
                              width: 200,
                              child: Text(
                                audit.description,
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            )),
                            DataCell(Container(
                              width: 200,
                              child: Text(
                                audit.purpose,
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            )),
                            DataCell(Container(
                              width: 120,
                              child: Text(
                                employee.name,
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            )),
                            DataCell(Container(
                              width: 60,
                              child: Text(
                                revizor.name,
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            )),
                            DataCell(Container(
                              width: 200,
                              child: Text(
                                audit.comments,
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            )),
                            DataCell(
                              Container(
                                width: 60,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, size: 16),
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      onPressed: () => _showEditDialog(
                                          context, audit, auditProvider),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, size: 16),
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      onPressed: () => _showDeleteDialog(
                                          context, audit.id, auditProvider),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.print, size: 16),
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      onPressed: () => _printAudit(
                                          audit, department, employee),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
