import 'package:flutter/cupertino.dart';
import 'package:privatenotes/Pages/note_page.dart';

Widget noNotesView(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("No notes. Tap below to create a new one."),
        CupertinoButton(
          child: Text("New Note"),
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => notePage(context),
            ));
          },
        )
      ],
    ),
  );
}
