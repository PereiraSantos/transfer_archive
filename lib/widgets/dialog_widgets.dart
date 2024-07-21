import 'package:flutter/material.dart';
import 'package:transfer_archive/entities/devices.dart';
import 'package:transfer_archive/entities/folder.dart';
import 'package:transfer_archive/utils/emulator.dart';
import 'package:transfer_archive/widgets/list_emulator.dart';

class DialogWidgets {
  Future<void> show(BuildContext context, List<Folder> emulatorExec) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: Emulator().listEmulator(),
                builder: (BuildContext context, AsyncSnapshot<List<Devices>> snapshot) {
                  if (snapshot.hasData) {
                    return ListEmulator(listEmulator: snapshot.data!, emulatorExec: emulatorExec);
                  }
                  return const Center(
                      child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator()));
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('FECHAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
