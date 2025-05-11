// utils/date_utils.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtils {
  static Future<void> selectDate({
    required BuildContext context,
    required TextEditingController controller,
    required Function(DateTime) onDateSelected,
  }) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      onDateSelected(selectedDate);
      controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }
}