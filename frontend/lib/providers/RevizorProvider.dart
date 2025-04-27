import 'package:flutter/cupertino.dart';

import '../api/ApiService.dart';
import '../models/Revizor.dart';

class RevizorProvider extends ChangeNotifier {
  List<Revizor> _revizors = [];
  bool _isLoading = false;

  List<Revizor> get revizors => _revizors;
  bool get isLoading => _isLoading;

  RevizorProvider() {
    fetchRevizors();
  }

  void fetchRevizors() async {
    _isLoading = true;
    notifyListeners();

    _revizors = await ApiService().fetchRevizors();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createRevizor(String name) async {
    final newRevizor = await ApiService().createRevizor(name);
    _revizors.add(newRevizor);
    notifyListeners();
  }

  Future<void> updateRevizor(int id, String name) async {
    final updatedRevizor = await ApiService().updateRevizor(id, name);
    int index = _revizors.indexWhere((revizor) => revizor.id == id);
    if (index != -1) {
      _revizors[index] = updatedRevizor;
      notifyListeners();
    }
  }

  Future<void> deleteRevizor(int id) async {
    await ApiService().deleteRevizor(id);
    _revizors.removeWhere((revizor) => revizor.id == id);
    notifyListeners();
  }
}