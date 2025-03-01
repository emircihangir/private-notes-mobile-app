import 'package:flutter/cupertino.dart';
import 'package:privatenotes/main.dart';

Widget noNotesView(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("No notes. Tap below to create a new one."),
        CupertinoButton(
          child: Text("New Note"),
          onPressed: () => createNewNote(context),
        )
      ],
    ),
  );
}
