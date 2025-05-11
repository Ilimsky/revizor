import 'package:flutter/cupertino.dart';

import '../api/ApiService.dart';
import '../models/Audit.dart';

class AuditProvider extends ChangeNotifier {
  List<Audit> _audits = [];
  bool _isLoading = false;

  List<Audit> get audits => _audits;
  bool get isLoading => _isLoading;

  void fetchAuditsByDepartment(int departmentId) async {
    _isLoading = true;
    notifyListeners();

    _audits = await ApiService().fetchAuditsByDepartment(departmentId);
    _isLoading = false;
    notifyListeners();
  }

  void fetchAllAudits() async {
    _isLoading = true;
    notifyListeners();

    try {
      _audits = await ApiService().fetchAllAudits();
    } catch (e) {
      // Handle error appropriately
      print('Error fetching audits: $e');
      // You might want to show an error message to the user
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAudit({
    required int departmentId,
    required int employeeId,
    required int revizorId,
    required String dateReceived,
    required String ticket,
    required String description,
    required String purpose,
    required String comments,
  }) async {
    final newAudit = await ApiService().createAudit(
      departmentId: departmentId,
      employeeId: employeeId,
      revizorId: revizorId,
      dateReceived: dateReceived,
      ticket: ticket,
      description: description,
      purpose: purpose,
      comments: comments,
    );
    _audits.add(newAudit);
    notifyListeners();
  }

  Future<void> updateAudit(
      int id,
      int auditNumber,
      int departmentId, {
        required String ticket,
        required String description,
        required String purpose,
        required int employeeId,
        required int revizorId,
        required String comments,
      }) async {
    try {
      final index = audits.indexWhere((a) => a.id == id);
      if (index != -1) {
        // Сначала обновляем на сервере
        final updatedAudit = await ApiService().updateAudit(
          id,
          auditNumber: auditNumber,
          departmentId: departmentId,
          ticket: ticket,
          description: description,
          purpose: purpose,
          employeeId: employeeId,
          revizorId: revizorId,
          comments: comments,
        );

        // Затем обновляем локально
        _audits[index] = updatedAudit;
        notifyListeners();
      }
    } catch (e) {
      print('Ошибка при обновлении проверки: $e');
      // Можно показать пользователю сообщение об ошибке
      rethrow;
    }
  }

  Future<void> deleteAudit(int auditId) async {
    await ApiService().deleteAudit(auditId);
    _audits.removeWhere((audit) => audit.id == auditId);
    notifyListeners();
  }

  void sortAudits(Comparator<Audit> comparator) {
    _audits.sort(comparator);
    notifyListeners();
  }
}