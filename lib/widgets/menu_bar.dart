import 'package:flutter/material.dart';
import 'package:transfer_archive/page/home_page_emulator.dart';
import 'package:transfer_archive/page/home_page_transfer.dart';

class MenuBarUtils extends StatelessWidget {
  const MenuBarUtils({super.key, required this.child});

  final Widget child;

  void navigator(BuildContext context, dynamic page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: MenuBar(
                children: <Widget>[
                  SubmenuButton(
                    menuChildren: <Widget>[
                      MenuItemButton(
                        onPressed: () => navigator(context, const HomePageEmulator()),
                        child: const MenuAcceleratorLabel('&Emuladores'),
                      ),
                      MenuItemButton(
                        onPressed: () => navigator(context, const HomePageTransfer()),
                        child: const MenuAcceleratorLabel('&Transferir'),
                      ),
                    ],
                    child: const MenuAcceleratorLabel('&Menu'),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(child: child),
      ],
    );
  }
}
