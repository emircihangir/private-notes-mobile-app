//TODO: delete this before production.
import 'package:flutter/cupertino.dart';

Widget dummyNotesView(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      children: [
        CupertinoListTile(title: CupertinoSearchTextField()),
        CupertinoListSection(
          topMargin: 0,
          hasLeading: false,
          backgroundColor: CupertinoColors.systemBackground,
          children: [
            CupertinoListTile(
              title: Text("note 1"),
              subtitle: Text("note 1 subtitle"),
              onTap: () {},
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
          ],
        ),
      ],
    ),
  );
}
