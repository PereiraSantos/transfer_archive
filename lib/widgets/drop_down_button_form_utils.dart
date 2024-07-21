import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DropdownButtonFormFieldUtils<T> extends StatelessWidget {
  int? dropdownValue;
  List<T> list = [];
  Function(dynamic) onChanged;
  final String title;
  DropdownMenuItem<int> Function(T) dropdownMenuItem;

  DropdownButtonFormFieldUtils({
    super.key,
    required this.list,
    required this.onChanged,
    required this.title,
    required this.dropdownMenuItem,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      hint: Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      value: dropdownValue,
      icon: const Icon(Icons.expand_more),
      elevation: 16,
      isExpanded: true,
      isDense: true,
      style: const TextStyle(color: Colors.black54),
      onChanged: (int? value) => onChanged(value),
      items: list.map<DropdownMenuItem<int>>((value) => dropdownMenuItem(value)).toList(),
    );
  }
}
