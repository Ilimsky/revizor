import 'package:intl/intl.dart';

import '../../models/Audit.dart';
import '../../models/Department.dart';
import '../../models/Employee.dart';
import '../../models/Revizor.dart';
import '../../providers/AuditProvider.dart';
import '../../providers/DepartmentProvider.dart';
import '../../providers/EmployeeProvider.dart';
import '../../providers/RevizorProvider.dart';

class AuditTableUtils {
  static DateFormat get dateFormat => DateFormat('dd.MM.yyyy');

  static List<Audit> filterAudits({
    required List<Audit> audits,
    required String searchQuery,
    required DepartmentProvider departmentProvider,
    required EmployeeProvider employeeProvider,
    required RevizorProvider revizorProvider,
  }) {
    if (searchQuery.isEmpty) return audits;

    return audits.where((audit) {
      final department = departmentProvider.departments.firstWhere(
            (d) => d.id == audit.departmentId,
        orElse: () => Department(id: 0, name: ''),
      );
      final employee = employeeProvider.employees.firstWhere(
            (e) => e.id == audit.employeeId,
        orElse: () => Employee(id: 0, name: ''),
      );
      final revizor = revizorProvider.revizors.firstWhere(
            (a) => a.id == audit.revizorId,
        orElse: () => Revizor(id: 0, name: ''),
      );

      final dateReceivedStr = dateFormat.format(audit.dateReceived);

      final query = searchQuery.toLowerCase();
      return audit.auditNumber.toString().contains(query) ||
          dateReceivedStr.toLowerCase().contains(query) ||
          audit.ticket.toLowerCase().contains(query) ||
          audit.purpose.toLowerCase().contains(query) ||
          audit.comments.toLowerCase().contains(query) ||
          department.name.toLowerCase().contains(query) ||
          employee.name.toLowerCase().contains(query) ||
          revizor.name.toLowerCase().contains(query);
    }).toList();
  }

  static void sortAudits<T>({
    required Comparable<T> Function(Audit r) getField,
    required int columnIndex,
    required bool ascending,
    required AuditProvider provider,
    required Function(int, bool) updateSortState,
  }) {
    provider.audits.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    updateSortState(columnIndex, ascending);
  }
}