import 'dart:io';

import 'package:transfer_archive/entities/folder.dart';

class WriteDisc {
  Future<void> write(String value) async {
    await Process.run('mkdir', ['emulator_exec'], workingDirectory: '/tmp/');
    await Process.run('touch', ['emulator_exec/$value'], workingDirectory: '/tmp/');
  }

  Future<List<Folder>> read() async {
    try {
      var result = await Process.run('ls', ['-a'], workingDirectory: '/tmp/emulator_exec');
      List<Folder> folder = [];
      int id = 0;

      for (var item in result.stdout.toString().split('\n')) {
        if (item != '' && item != '.' && item != '..') folder.add(Folder(id, item.trim()));
        id += 1;
      }

      return folder;
    } catch (e) {
      return [];
    }
  }
}
