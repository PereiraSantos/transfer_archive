import 'package:flutter/material.dart';
import 'package:transfer_archive/entities/devices.dart';
import 'package:transfer_archive/utils/emulator.dart';
import 'package:transfer_archive/widgets/list_emulator.dart';
import 'package:transfer_archive/widgets/menu_bar.dart';

class HomePageEmulator extends StatelessWidget {
  const HomePageEmulator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MenuBarUtils(
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                    child: Text('Emuladores'),
                  ),
                ),
                FutureBuilder(
                  future: Emulator().listEmulator(),
                  builder: (BuildContext context, AsyncSnapshot<List<Devices>> snapshot) {
                    if (snapshot.hasData) return ListEmulator(listEmulator: snapshot.data!);
                    return const Center(
                        child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
