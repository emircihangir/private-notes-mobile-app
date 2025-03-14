import 'package:flutter/cupertino.dart';
import 'package:privatenotes/Pages/note_page.dart';

Widget noNotesView(BuildContext context) {
  return Center(
    child: CupertinoButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Icon(
            CupertinoIcons.text_badge_plus,
            size: 100,
          ),
          Text("Create a note")
        ],
      ),
      onPressed: () {
        // Navigator.of(context).push(CupertinoPageRoute(
        //   builder: (context) => notePage(context),
        // ));

        Navigator.of(context).pushNamed("/notePage", arguments: {
          "noteID": null
        });
      },
    ),
  );
}
