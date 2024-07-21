import 'package:flutter/material.dart';
import 'package:transfer_archive/entities/devices.dart';
import 'package:transfer_archive/entities/folder.dart';
import 'package:transfer_archive/utils/emulator.dart';
import 'package:transfer_archive/utils/write_disc.dart';
import 'package:transfer_archive/widgets/check_box.dart';

// ignore: must_be_immutable
class ListEmulator extends StatefulWidget {
  ListEmulator({super.key, required this.listEmulator, required this.emulatorExec});

  List<Devices> listEmulator = [];
  List<Folder> emulatorExec = [];

  @override
  State<ListEmulator> createState() => _ListEmulatorState();
}

class _ListEmulatorState extends State<ListEmulator> {
  String? emulator;
  String? message;
  int? index;
  bool emulatorExeculted = false;

  void updateList(bool value, int indexTemp, String emulatorName) {
    index = indexTemp;
    for (var i = 0; i < widget.listEmulator.length; i++) {
      if (i == index) {
        widget.listEmulator[i].select = value;
        emulator = value ? emulatorName : null;
        if (emulatorName != '') message = null;
      } else {
        widget.listEmulator[i].select = false;
      }
    }
    setState(() {});
  }

  bool getEmulatorExec(String value) {
    var result = widget.emulatorExec.where((e) => e.name == value).toList();
    return result.length == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            itemCount: widget.listEmulator.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              bool exec = getEmulatorExec(widget.listEmulator[index].name);
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CheckBoxWidgets(
                            onClick: (value) => updateList(value, index, widget.listEmulator[index].name),
                            select: widget.listEmulator[index].select),
                      ),
                      Expanded(
                        flex: 6,
                        child: DefaultTextStyle(
                          style: TextStyle(fontSize: 14, color: exec ? Colors.green : Colors.grey),
                          child: Text(
                            widget.listEmulator[index].name,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Visibility(
                          visible: exec,
                          child: const Text(
                            '*Exec',
                            style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w400),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
          Visibility(
            visible: (emulator != null),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  message = null;
                  emulatorExeculted = true;
                  setState(() {});
                  await WriteDisc().write(emulator!);

                  String? result = await Emulator().initEmulator(emulator!);
                  if (result != null &&
                      (result.contains('PANIC') || result.contains('Running multiple emulators'))) {
                    message = result;
                  }
                  emulator = null;
                  emulatorExeculted = false;
                  updateList(false, index ?? -1, '');
                },
                style: TextButton.styleFrom(foregroundColor: Colors.black54, backgroundColor: Colors.white),
                child: const Text("iniciar emulador"),
              ),
            ),
          ),
          Visibility(
            visible: (message != null),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w400),
                child: Text(message ?? ''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
