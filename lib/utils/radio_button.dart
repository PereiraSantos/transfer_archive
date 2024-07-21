import 'package:flutter/material.dart';

enum ActionButtom { download, database, shared, pull }

class Button {
  String title;
  ActionButtom type;
  Button(this.title, this.type);
}

class RadioButonUtils {
  final ActionButtom group;
  final Function(ActionButtom) click;
  List<Button> radios = [];

  RadioButonUtils({required this.radios, required this.click, required this.group});

  List<Widget> build(BuildContext context) {
    return radios.map((element) {
      return ListTile(
        title: Text(element.title),
        dense: true,
        minLeadingWidth: 1.0,
        minTileHeight: 1.0,
        contentPadding: const EdgeInsets.only(left: 5, bottom: 0),
        leading: Radio<ActionButtom>(
          value: element.type,
          groupValue: group,
          onChanged: (ActionButtom? value) => click(value!),
        ),
      );
    }).toList();
  }
}
