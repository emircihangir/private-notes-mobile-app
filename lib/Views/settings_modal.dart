import 'package:flutter/cupertino.dart';

Widget settingsModal = CupertinoActionSheet(
  actions: [
    CupertinoActionSheetAction(onPressed: () {}, child: const Text("Export Notes")),
    CupertinoActionSheetAction(onPressed: () {}, child: const Text("Import Notes")),
    CupertinoActionSheetAction(onPressed: () {}, child: const Text("Turn Off Auto-Export")),
    CupertinoActionSheetAction(onPressed: () {}, child: const Text("Help")),
  ],
);
