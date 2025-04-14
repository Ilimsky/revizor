import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import '../../models/Department.dart';
import '../../models/Employee.dart';
import '../../providers/DepartmentProvider.dart';
import '../../providers/EmployeeProvider.dart';
import '../../models/Audit.dart';
import '../../providers/AuditProvider.dart';

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
      // final job = Provider.of<JobProvider>(context, listen: false)
      //     .jobs
      //     .firstWhere((j) => j.id == audit.jobId, orElse: () => Job(id: 0, name: ''));
      final employee = Provider.of<EmployeeProvider>(context, listen: false)
          .employees
          .firstWhere((e) => e.id == audit.employeeId,
              orElse: () => Employee(id: 0, name: ''));
      // final account = Provider.of<AccountProvider>(context, listen: false)
      //     .accounts
      //     .firstWhere((a) => a.id == audit.accountId,
      //         orElse: () => Account(id: 0, name: ''));

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
          audit.purpose.toLowerCase().contains(query) ||
          audit.comments.toLowerCase().contains(query) ||
          department.name.toLowerCase().contains(query) ||
          // job.name.toLowerCase().contains(query) ||
          employee.name.toLowerCase().contains(query);
          // account.name.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _printAudit(Audit audit, Department department,
      Employee employee) async {
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
    TextEditingController controller =
        TextEditingController(text: audit.auditNumber.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Редактировать отчет'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Новый номер отчета'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              final newAuditNumber =
                  int.tryParse(controller.text) ?? audit.auditNumber;
              auditProvider.updateAudit(
                audit.id,
                newAuditNumber,
                audit.departmentId,
              );
              Navigator.pop(context);
            },
            child: Text('Сохранить'),
          ),
        ],
      ),
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

    final filteredAudits = _filteredAudits(auditProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Отчеты'),
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
                              width: 40,
                              child: Text(
                                'Номер отчета',
                                style: TextStyle(fontSize: 10),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onSort: (i, asc) => _sort<num>(
                                (r) => r.auditNumber, i, asc, auditProvider),
                          ),
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
                          // DataColumn(
                          //   label: Container(
                          //     width: 60,
                          //     child: Text(
                          //       'Счет',
                          //       style: TextStyle(fontSize: 10),
                          //       softWrap: true,
                          //       overflow: TextOverflow.visible,
                          //       maxLines: 1,
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          //   onSort: (i, asc) => _sort<String>(
                          //     (r) => accountProvider.accounts
                          //         .firstWhere((a) => a.id == r.accountId,
                          //             orElse: () =>
                          //                 Account(id: 0, name: 'Неизвестно'))
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
                          // final job = jobProvider.jobs.firstWhere(
                          //       (j) => j.id == audit.jobId,
                          //   orElse: () => Job(id: 0, name: 'Неизвестно'),
                          // );
                          final employee =
                              employeeProvider.employees.firstWhere(
                            (e) => e.id == audit.employeeId,
                            orElse: () => Employee(id: 0, name: 'Неизвестно'),
                          );
                          // final account = accountProvider.accounts.firstWhere(
                          //   (a) => a.id == audit.accountId,
                          //   orElse: () => Account(id: 0, name: 'Неизвестно'),
                          // );

                          return DataRow(cells: [
                            DataCell(Container(
                              width: 40,
                              child: Text(
                                '${audit.auditNumber}/${department.name}',
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            )),
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
                            // DataCell(Container(
                            //   width: 90,
                            //   child: Text(
                            //     audit.amountIssued,
                            //     style: TextStyle(fontSize: 12),
                            //     overflow: TextOverflow.ellipsis,
                            //     maxLines: 1,
                            //     textAlign: TextAlign.center,
                            //     softWrap: true,
                            //   ),
                            // )),
                            // DataCell(Container(
                            //   width: 80,
                            //   child: Text(
                            //     audit.dateApproved != null
                            //         ? _dateFormat.format(audit.dateApproved!)
                            //         : '',
                            //     style: TextStyle(fontSize: 12),
                            //     overflow: TextOverflow.ellipsis,
                            //     maxLines: 1,
                            //     textAlign: TextAlign.center,
                            //     softWrap: true,
                            //   ),
                            // )),
                            // DataCell(Container(
                            //   width: 100,
                            //   child: Text(
                            //     // job.name,
                            //     style: TextStyle(fontSize: 12),
                            //     overflow: TextOverflow.ellipsis,
                            //     maxLines: 2,
                            //     textAlign: TextAlign.center,
                            //     softWrap: true,
                            //   ),
                            // )),

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
                            // DataCell(Container(
                            //   width: 90,
                            //   child: Text(
                            //     audit.recognizedAmount,
                            //     style: TextStyle(fontSize: 12),
                            //     overflow: TextOverflow.ellipsis,
                            //     maxLines: 1,
                            //     textAlign: TextAlign.center,
                            //     softWrap: true,
                            //   ),
                            // )),
                            // DataCell(Container(
                            //   width: 60,
                            //   child: Text(
                            //     account.name,
                            //     style: TextStyle(fontSize: 12),
                            //     overflow: TextOverflow.ellipsis,
                            //     maxLines: 1,
                            //     textAlign: TextAlign.center,
                            //     softWrap: true,
                            //   ),
                            // )),
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
                                      onPressed: () => _printAudit(audit,
                                          department, employee),
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
