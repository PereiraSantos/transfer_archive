import 'dart:io';

import 'package:transfer_archive/entities/devices.dart';
import 'package:transfer_archive/entities/folder.dart';

class Emulator {
  Future<List<Devices>> listEmulator() async {
    var result = await Process.run('emulator', ['-list-avds'], workingDirectory: '/');

    List<Devices> devices = [];
    int id = 1;

    for (String item in result.stdout.toString().split('\n')) {
      id += 1;
      if (item != '') devices.add(Devices(id, item, false));
    }

    return devices;
  }

  Future<String?> initEmulator(String emulator) async {
    var result = await Process.run('emulator', ['-avd', emulator], workingDirectory: '/');
    return result.stderr;
  }

  Future<bool> quantityEmulator() async {
    var result = await listDevices();

    if (result.stdout.toString().split('\n').length > 4) return false;
    return true;
  }

  Future<String?> initRootEmulator() async {
    var result = await Process.run('adb', ['root'], workingDirectory: '/');
    return result.stdout;
  }

  Future<List<Devices>> listEmulatorExecuted() async {
    var result = await listDevices();

    List<Devices> devices = [];
    int id = 0;

    for (var item in result.stdout.toString().split('\n')) {
      if (item != '' && !item.contains('List of devices')) {
        devices.add(Devices(id, item.replaceAll('device', '').trim(), false));
        id += 1;
      }
    }
    return devices;
  }

  Future<dynamic> listDevices() async => await Process.run('adb', ['devices'], workingDirectory: '/');

  Future<List<Folder>> listFolder(String emulator) async {
    var result =
        await Process.run('adb', ['-s', emulator, 'shell', 'ls', '/data/data/'], workingDirectory: '/');

    List<Folder> folder = [];
    int id = 0;

    for (var item in result.stdout.toString().split('\n')) {
      if (item != '') folder.add(Folder(id, item.trim()));
      id += 1;
    }

    return folder;
  }

  Future<List<Folder>> listDatabase(String emulator, String database) async {
    var result = await Process.run('adb', ['-s', emulator, 'shell', 'ls', '/data/data/$database/databases/'],
        workingDirectory: '/');

    List<Folder> folder = [];
    int id = 0;

    for (var item in result.stdout.toString().split('\n')) {
      if (item != '') folder.add(Folder(id, item.trim()));
      id += 1;
    }

    return folder;
  }

  Future<List<Folder>> listShared(String emulator, String shared) async {
    var result = await Process.run('adb', ['-s', emulator, 'shell', 'ls', '/data/data/$shared/shared_prefs/'],
        workingDirectory: '/');

    List<Folder> folder = [];
    int id = 0;

    for (var item in result.stdout.toString().split('\n')) {
      if (item != '') folder.add(Folder(id, item.trim()));
      id += 1;
    }

    return folder;
  }

  Future<String> getDatabase(String emulator, String folder, String database, directory) async {
    var result = await Process.run(
        'adb', ['-s', emulator, 'pull', '/data/data/$folder/databases/$database', directory],
        workingDirectory: '/');

    return result.stdout;
  }

  Future<String> getSharedPrefs(String emulator, String folder, String shared, directory) async {
    var result = await Process.run(
        'adb', ['-s', emulator, 'pull', '/data/data/$folder/shared_prefs/$shared', directory],
        workingDirectory: '/');

    return result.stdout;
  }
}
