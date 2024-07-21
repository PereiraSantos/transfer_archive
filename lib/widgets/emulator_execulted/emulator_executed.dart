import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:transfer_archive/entities/devices.dart';
import 'package:transfer_archive/entities/folder.dart';
import 'package:transfer_archive/widgets/drop_down_button_form_utils.dart';
import 'package:transfer_archive/utils/emulator.dart';
import 'package:transfer_archive/utils/radio_button.dart';

// ignore: must_be_immutable
class EmulatorExecuted extends StatefulWidget {
  EmulatorExecuted({super.key, required this.devices});

  List<Devices> devices = [];

  @override
  State<EmulatorExecuted> createState() => _EmulatorExecutedState();
}

class _EmulatorExecutedState extends State<EmulatorExecuted> {
  int? dropdownValue;
  int? dropdownValueDb;
  int? emulador;
  String? folder;
  String? database;
  String? shared;
  ActionButtom _action = ActionButtom.download;
  String? selectedDirectory;
  FilePickerResult? selectedDirectoryFile;
  String? messageSuccess;

  Future<List<Folder>> listFolder() async {
    if (emulador == null) return [];
    return await Emulator().listFolder(widget.devices[emulador!].name);
  }

  Future<List<Folder>> listDatabase() async {
    if (emulador == null || folder == null) return [];
    return await Emulator().listDatabase(widget.devices[emulador!].name, folder!);
  }

  Future<List<Folder>> listShared() async {
    if (emulador == null || folder == null) return [];
    return await Emulator().listShared(widget.devices[emulador!].name, folder!);
  }

  void changeButton(ActionButtom value) {
    _action = value;

    if (value == ActionButtom.database || value == ActionButtom.download || value == ActionButtom.shared) {
      selectedDirectory = null;
    }
    if (value == ActionButtom.pull) selectedDirectoryFile = null;
    setState(() {});
  }

  Widget dropdownMenuItemText(String value) {
    return Text(
      value,
      style: const TextStyle(fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: DropdownButtonFormFieldUtils(
                      list: widget.devices,
                      onChanged: (value) {
                        emulador = value;
                        setState(() {});
                      },
                      title: 'Emuladores',
                      dropdownMenuItem: (value) {
                        return DropdownMenuItem<int>(
                            value: value.id, child: dropdownMenuItemText(value.name));
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, top: 15, bottom: 5),
                    child: DefaultTextStyle(
                      style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w400),
                      child: Text('Transferir para'),
                    ),
                  ),
                  ...RadioButonUtils(
                    radios: [
                      Button('Download', ActionButtom.download),
                      Button('Database', ActionButtom.database),
                      Button('Shared', ActionButtom.shared),
                      Button('Pasta', ActionButtom.pull)
                    ],
                    group: _action,
                    click: (value) => changeButton(value),
                  ).build(context),
                  Visibility(
                    visible: (emulador != null),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          selectedDirectory = null;
                          selectedDirectoryFile = null;
                          if (_action == ActionButtom.pull) {
                            String? directory = await FilePicker.platform.getDirectoryPath();

                            if (directory != null) selectedDirectory = directory;
                            setState(() {});
                          } else {
                            FilePickerResult? directoryFile = await FilePicker.platform.pickFiles();

                            if (directoryFile != null) selectedDirectoryFile = directoryFile;
                            setState(() {});
                          }
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black54, backgroundColor: Colors.white),
                        child: Text(_action == ActionButtom.pull ? "Selecionar Pasta" : "Selecionar Arquivo"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 15),
                child: Column(
                  children: [
                    Visibility(
                      visible: (emulador != null),
                      child: FutureBuilder(
                        future: listFolder(),
                        builder: (BuildContext context, AsyncSnapshot<List<Folder>> snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormFieldUtils(
                              list: snapshot.data!,
                              onChanged: (value) {
                                folder = snapshot.data![value].name;
                                setState(() {});
                              },
                              title: 'Projeto',
                              dropdownMenuItem: (value) {
                                return DropdownMenuItem<int>(
                                    value: value.id, child: dropdownMenuItemText(value.name));
                              },
                            );
                          }
                          return const Center(
                              child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator()));
                        },
                      ),
                    ),
                    Visibility(
                      visible: (folder != null),
                      child: FutureBuilder(
                        future: listDatabase(),
                        builder: (BuildContext context, AsyncSnapshot<List<Folder>> snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormFieldUtils(
                              list: snapshot.data!,
                              onChanged: (value) {
                                database = snapshot.data![value].name;
                                setState(() {});
                              },
                              title: 'Database',
                              dropdownMenuItem: (value) {
                                return DropdownMenuItem<int>(
                                    value: value.id, child: dropdownMenuItemText(value.name));
                              },
                            );
                          }
                          return const Center(
                              child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator()));
                        },
                      ),
                    ),
                    Visibility(
                      visible: (folder != null),
                      child: FutureBuilder(
                        future: listShared(),
                        builder: (BuildContext context, AsyncSnapshot<List<Folder>> snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormFieldUtils(
                              list: snapshot.data!,
                              onChanged: (value) {
                                shared = snapshot.data![value].name;
                                setState(() {});
                              },
                              title: 'Shared',
                              dropdownMenuItem: (value) {
                                return DropdownMenuItem<int>(
                                    value: value.id, child: dropdownMenuItemText(value.name));
                              },
                            );
                          }
                          return const Center(
                              child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Visibility(
                visible: (selectedDirectory != null || selectedDirectoryFile != null),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultTextStyle(
                    style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                    child: Text(selectedDirectory != null
                        ? 'Salvar em: ${selectedDirectory ?? ''}'
                        : 'Arquivo: ${selectedDirectoryFile?.names.first ?? ''}'),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Visibility(
                visible: (selectedDirectory != null),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      var result = await Emulator()
                          .getDatabase(widget.devices[emulador!].name, folder!, database!, selectedDirectory);
                      messageSuccess = result;
                      if (shared != null) {
                        var result = await Emulator().getSharedPrefs(
                            widget.devices[emulador!].name, folder!, shared!, selectedDirectory);
                        messageSuccess = result;
                      }

                      setState(() {});
                    },
                    style:
                        TextButton.styleFrom(foregroundColor: Colors.black54, backgroundColor: Colors.white),
                    child: const Text("Finalisar"),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    selectedDirectory = null;
                    setState(() {});
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.black54, backgroundColor: Colors.white),
                  child: const Text("Resetar"),
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: (selectedDirectory != null),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
              child: Text(messageSuccess ?? ''),
            ),
          ),
        ),
      ],
    );
  }
}
