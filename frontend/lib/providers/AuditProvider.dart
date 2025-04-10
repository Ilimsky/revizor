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

    _audits = await ApiService().fetchAllAudits();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createAudit({
    required int departmentId,
    required String dateReceived,
    required String amountIssued,
    required String dateApproved,
    required String purpose,
    required String recognizedAmount,
    required String comments,
  }) async {
    final newAudit = await ApiService().createAudit(
      departmentId: departmentId,
      dateReceived: dateReceived,
      amountIssued: amountIssued,
      dateApproved: dateApproved,
      purpose: purpose,
      recognizedAmount: recognizedAmount,
      comments: comments,
    );
    _audits.add(newAudit);
    notifyListeners();
  }

  Future<void> updateAudit(int auditId, int auditNumber, int departmentId) async {
    final updatedAudit = await ApiService().updateAudit(auditId, auditNumber, departmentId);
    int index = _audits.indexWhere((audit) => audit.id == auditId);
    if (index != -1) {
      _audits[index] = updatedAudit;
      notifyListeners();
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