//TODO: delete this before production.
import 'package:flutter/cupertino.dart';

Widget dummyNotesView(BuildContext context) {
  List<Widget> dummyNotes() {
    List<Widget> widgets = [];
    for (var i = 0; i < 10; i++) {
      widgets.add(CupertinoListTile(title: Text("Note ${i + 1}")));
    }
    return widgets;
  }

  return SingleChildScrollView(
    child: Column(
      children: [
        CupertinoListTile(title: CupertinoSearchTextField()),
        CupertinoListSection(
          topMargin: 0,
          hasLeading: false,
          backgroundColor: CupertinoColors.systemBackground,
          children: dummyNotes(),
        ),
      ],
    ),
  );
}
