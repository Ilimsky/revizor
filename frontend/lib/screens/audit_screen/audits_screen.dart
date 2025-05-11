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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Audit.dart';
import '../../providers/AuditProvider.dart';
import '../../providers/DepartmentProvider.dart';
import '../../providers/EmployeeProvider.dart';
import '../../providers/RevizorProvider.dart';
import 'audit_dialogs.dart';
import 'audit_table_utils.dart';

class AuditsScreen extends StatefulWidget {
  @override
  _AuditsScreenState createState() => _AuditsScreenState();
}

class _AuditsScreenState extends State<AuditsScreen> {
  int _sortColumnIndex = 0;
  bool _isAscending = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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

  void _updateSortState(int columnIndex, bool isAscending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = isAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auditProvider = Provider.of<AuditProvider>(context);
    final departmentProvider = Provider.of<DepartmentProvider>(context);
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final revizorProvider = Provider.of<RevizorProvider>(context);

    final filteredAudits = AuditTableUtils.filterAudits(
      audits: auditProvider.audits,
      searchQuery: _searchQuery,
      departmentProvider: departmentProvider,
      employeeProvider: employeeProvider,
      revizorProvider: revizorProvider,
    );

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
                      onSort: (i, asc) => AuditTableUtils.sortAudits<DateTime>(
                        getField: (r) => r.dateReceived,
                        columnIndex: i,
                        ascending: asc,
                        provider: auditProvider,
                        updateSortState: _updateSortState,
                      ),
                    ),
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
                      onSort: (i, asc) => AuditTableUtils.sortAudits<String>(
                        getField: (r) => r.ticket,
                        columnIndex: i,
                        ascending: asc,
                        provider: auditProvider,
                        updateSortState: _updateSortState,
                      ),
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
                      onSort: (i, asc) => AuditTableUtils.sortAudits<String>(
                        getField: (r) => r.description,
                        columnIndex: i,
                        ascending: asc,
                        provider: auditProvider,
                        updateSortState: _updateSortState,
                      ),
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
                      onSort: (i, asc) => AuditTableUtils.sortAudits<String>(
                        getField: (r) => r.purpose,
                        columnIndex: i,
                        ascending: asc,
                        provider: auditProvider,
                        updateSortState: _updateSortState,
                      ),
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
                      onSort: (i, asc) => AuditTableUtils.sortAudits<String>(
                        getField: (r) => employeeProvider.employees
                            .firstWhere((e) => e.id == r.employeeId,
                            orElse: () =>
                                Employee(id: 0, name: 'Неизвестно'))
                            .name,
                        columnIndex: i,
                        ascending: asc,
                        provider: auditProvider,
                        updateSortState: _updateSortState,
                      ),
                    ),
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
                      onSort: (i, asc) => AuditTableUtils.sortAudits<String>(
                        getField: (r) => revizorProvider.revizors
                            .firstWhere((a) => a.id == r.revizorId,
                            orElse: () =>
                                Revizor(id: 0, name: 'Неизвестно'))
                            .name,
                        columnIndex: i,
                        ascending: asc,
                        provider: auditProvider,
                        updateSortState: _updateSortState,
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
                      onSort: (i, asc) => AuditTableUtils.sortAudits<String>(
                        getField: (r) => r.comments,
                        columnIndex: i,
                        ascending: asc,
                        provider: auditProvider,
                        updateSortState: _updateSortState,
                      ),
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
                          AuditTableUtils.dateFormat.format(audit.dateReceived),
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
                          '${department.name}/${audit.ticket}',
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
                                onPressed: () => AuditDialogs.showEditDialog(
                                  context: context,
                                  audit: audit,
                                  auditProvider: auditProvider,
                                  departmentProvider: departmentProvider,
                                  employeeProvider: employeeProvider,
                                  revizorProvider: revizorProvider,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, size: 16),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () => AuditDialogs.showDeleteDialog(
                                  context: context,
                                  auditId: audit.id,
                                  auditProvider: auditProvider,
                                ),
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