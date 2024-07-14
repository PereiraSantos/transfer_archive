import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transfer_archive/page/home_page_emulator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.white),
        useMaterial3: false,
      ),
      home: Shortcuts(shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.keyT, control: true): VoidCallbackIntent(() {
          debugDumpApp();
        }),
      }, child: const HomePageEmulator()),
    );
  }
}
