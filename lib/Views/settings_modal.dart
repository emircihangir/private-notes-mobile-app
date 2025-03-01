import 'package:flutter/cupertino.dart';

Widget settingsModal() {
  return CupertinoActionSheet(
    actions: [
      CupertinoActionSheetAction(onPressed: () {}, child: Text("Export Notes")),
      CupertinoActionSheetAction(onPressed: () {}, child: Text("Import Notes")),
      CupertinoActionSheetAction(onPressed: () {}, child: Text("Change the Password")),
      CupertinoActionSheetAction(onPressed: () {}, child: Text("Turn Off Auto-Export")),
      CupertinoActionSheetAction(onPressed: () {}, child: Text("Info")),
    ],
  );
}
