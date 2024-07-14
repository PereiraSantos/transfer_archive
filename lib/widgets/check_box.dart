import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CheckBoxWidgets extends StatefulWidget {
  CheckBoxWidgets({super.key, required this.select, required this.onClick});
  bool select;
  final Function(bool) onClick;

  @override
  State<CheckBoxWidgets> createState() => _CheckBoxWidgetsState();
}

class _CheckBoxWidgetsState extends State<CheckBoxWidgets> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Checkbox(
        checkColor: Colors.green,
        fillColor: WidgetStateProperty.all(Colors.white),
        activeColor: Colors.green,
        value: widget.select,
        onChanged: (bool? value) {
          setState(() {
            widget.select = value!;
            widget.onClick(value);
          });
        },
      ),
    );
  }
}
