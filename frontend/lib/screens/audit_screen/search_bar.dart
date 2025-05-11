import 'package:flutter/material.dart';

class AuditSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final Function(String) onChanged;
  final Function() onClear;

  const AuditSearchBar({
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Поиск',
          hintText: 'Введите текст для поиска',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear),
            onPressed: onClear,
          )
              : null,
        ),
        onChanged: onChanged,
      ),
    );
  }
}