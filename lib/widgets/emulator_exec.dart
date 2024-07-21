import 'package:flutter/material.dart';
import 'package:transfer_archive/entities/folder.dart';
import 'package:transfer_archive/utils/emulator.dart';
import 'package:transfer_archive/utils/write_disc.dart';
import 'package:transfer_archive/widgets/dialog_widgets.dart';

class EmulatorExec extends StatefulWidget {
  const EmulatorExec({super.key});

  @override
  State<EmulatorExec> createState() => _EmulatorExecState();
}

class _EmulatorExecState extends State<EmulatorExec> {
  String? message;
  bool emulatorExeculted = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            List<Folder> emulatorExec = await WriteDisc().read();
            // ignore: use_build_context_synchronously
            await DialogWidgets().show(context, emulatorExec);
          },
          style: TextButton.styleFrom(foregroundColor: Colors.black54, backgroundColor: Colors.white),
          child: const Text("Emuladores"),
        ),
        const Padding(padding: EdgeInsets.all(2)),
        ElevatedButton(
          onPressed: () async {
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
          child: const Text("Iniciar root"),
        ),
        Container(
          height: 20,
          padding: const EdgeInsets.only(left: 10, top: 2),
          child: Visibility(
            visible: (message != null),
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
