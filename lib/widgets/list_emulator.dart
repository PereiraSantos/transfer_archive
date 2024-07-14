import 'package:flutter/material.dart';
import 'package:transfer_archive/entities/devices.dart';
import 'package:transfer_archive/utils/emulator.dart';
import 'package:transfer_archive/widgets/check_box.dart';

// ignore: must_be_immutable
class ListEmulator extends StatefulWidget {
  ListEmulator({super.key, required this.listEmulator});

  List<Devices> listEmulator = [];

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          itemCount: widget.listEmulator.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CheckBoxWidgets(
                        onClick: (value) => updateList(value, index, widget.listEmulator[index].name),
                        select: widget.listEmulator[index].select),
                    DefaultTextStyle(
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      child: Text(
                        widget.listEmulator[index].name,
                      ),
                    ),
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
                String? result = await Emulator().initEmulator(emulator!);
                if (result != null && result.contains('PANIC')) message = result;
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
          visible: emulatorExeculted,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                message = null;
                bool quantityEmulator = await Emulator().quantityEmulator();

                if (quantityEmulator) {
                  String? isInit = await Emulator().initRootEmulator();
                  if ((isInit ?? '').contains('adbd is already running as root')) emulatorExeculted = false;

                  message = isInit;
                } else {
                  message = 'Mais de um emulador em execução';
                }

                setState(() {});

                Future.delayed(const Duration(milliseconds: 2000), () {
                  message = null;
                  setState(() {});
                });
              },
              style: TextButton.styleFrom(foregroundColor: Colors.black54, backgroundColor: Colors.white),
              child: const Text("iniciar como root"),
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
    );
  }
}
