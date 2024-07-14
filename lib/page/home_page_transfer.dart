import 'package:flutter/material.dart';
import 'package:transfer_archive/entities/devices.dart';
import 'package:transfer_archive/utils/emulator.dart';
import 'package:transfer_archive/widgets/emulator_executed.dart';
import 'package:transfer_archive/widgets/menu_bar.dart';

class HomePageTransfer extends StatelessWidget {
  const HomePageTransfer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MenuBarUtils(
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            color: Colors.white,
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: Emulator().listEmulatorExecuted(),
                  builder: (BuildContext context, AsyncSnapshot<List<Devices>> snapshot) {
                    if (snapshot.hasData) return EmulatorExecuted(devices: snapshot.data!);

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
