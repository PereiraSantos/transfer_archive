import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:transfer_archive/entities/devices.dart';
import 'package:transfer_archive/entities/folder.dart';
import 'package:transfer_archive/utils/emulator.dart';

enum Action { download, database, shared, pull }

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
  Action _action = Action.download;
  String? selectedDirectory;
  String? messageSuccess;

  Widget radioButton(String title, Action type) {
    return ListTile(
      title: Text(title),
      dense: true,
      contentPadding: const EdgeInsets.only(left: 1, bottom: 0),
      leading: Radio<Action>(
        value: type,
        groupValue: _action,
        onChanged: (Action? value) {
          setState(() {
            _action = value!;
          });
        },
      ),
    );
  }

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
                    child: DropdownButtonFormField<int>(
                      hint: const Text("Emuladores", style: TextStyle(fontSize: 14, color: Colors.grey)),
                      value: dropdownValue,
                      icon: const Icon(Icons.expand_more),
                      elevation: 16,
                      isExpanded: true,
                      isDense: true,
                      style: const TextStyle(color: Colors.black54),
                      onChanged: (int? value) {
                        emulador = value;
                        setState(() {});
                      },
                      items: widget.devices.map<DropdownMenuItem<int>>((value) {
                        return DropdownMenuItem<int>(
                          value: value.id,
                          child: Text(
                            value.name,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  radioButton('Transferir para download', Action.download),
                  radioButton('Transferir para database', Action.database),
                  radioButton('Transferir para shared preference', Action.shared),
                  radioButton('Transferir para local', Action.pull),
                  Visibility(
                    visible: (emulador != null),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          String? directory = await FilePicker.platform.getDirectoryPath();

                          if (directory != null) selectedDirectory = directory;
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black54, backgroundColor: Colors.white),
                        child: const Text("Selecionar pasta"),
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
                            return DropdownButtonFormField<int>(
                              hint: const Text("Projeto", style: TextStyle(fontSize: 14, color: Colors.grey)),
                              value: dropdownValueDb,
                              icon: const Icon(Icons.expand_more),
                              elevation: 16,
                              isExpanded: true,
                              isDense: true,
                              style: const TextStyle(color: Colors.black54),
                              onChanged: (int? value) {
                                folder = snapshot.data![value!].name;
                                setState(() {});
                              },
                              items: snapshot.data!.map<DropdownMenuItem<int>>((value) {
                                return DropdownMenuItem<int>(
                                  value: value.id,
                                  child: Text(
                                    value.name,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
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
                            return DropdownButtonFormField<int>(
                              hint:
                                  const Text("Database", style: TextStyle(fontSize: 14, color: Colors.grey)),
                              value: dropdownValueDb,
                              icon: const Icon(Icons.expand_more),
                              elevation: 16,
                              isExpanded: true,
                              isDense: true,
                              style: const TextStyle(color: Colors.black54),
                              onChanged: (int? value) {
                                database = snapshot.data![value!].name;
                                setState(() {});
                              },
                              items: snapshot.data!.map<DropdownMenuItem<int>>((value) {
                                return DropdownMenuItem<int>(
                                  value: value.id,
                                  child: Text(
                                    value.name,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
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
                            return DropdownButtonFormField<int>(
                              hint: const Text("Shared", style: TextStyle(fontSize: 14, color: Colors.grey)),
                              value: dropdownValueDb,
                              icon: const Icon(Icons.expand_more),
                              elevation: 16,
                              isExpanded: true,
                              isDense: true,
                              style: const TextStyle(color: Colors.black54),
                              onChanged: (int? value) {
                                shared = snapshot.data![value!].name;
                                setState(() {});
                              },
                              items: snapshot.data!.map<DropdownMenuItem<int>>((value) {
                                return DropdownMenuItem<int>(
                                  value: value.id,
                                  child: Text(
                                    value.name,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
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
                visible: (selectedDirectory != null),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultTextStyle(
                    style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                    child: Text('Salvar em: ${selectedDirectory ?? ''}'),
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
