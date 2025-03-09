import 'package:flutter/cupertino.dart';
import 'package:privatenotes/Pages/note_page.dart';
import 'package:privatenotes/Views/no_notes_view.dart';
import 'package:privatenotes/main.dart';
import 'package:provider/provider.dart';

List<Widget> retrieveNoteWidgets(Map<dynamic, dynamic> data, BuildContext context) {
  List<Widget> result = [];
  data.forEach(
    (key, value) => result.add(CupertinoListTile(
      title: Text(value),
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => notePage(context, noteID: key),
        ));
      },
    )),
  );
  return result;
}

Widget notesView() {
  return SingleChildScrollView(
    child: Column(
      children: [
        CupertinoListTile(title: CupertinoSearchTextField()),
        Consumer<NoteTitlesModel>(
          builder: (context, value, child) {
            return CupertinoListSection(
              topMargin: 0,
              hasLeading: false,
              backgroundColor: CupertinoColors.systemBackground,
              children: retrieveNoteWidgets(value.value, context),
            );
          },
        )
      ],
    ),
  );
}

Widget notesPage(BuildContext context) {
  return CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(
      trailing: CupertinoButton(
          sizeStyle: CupertinoButtonSize.small,
          child: Icon(
            CupertinoIcons.text_badge_plus,
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => notePage(context),
            ));
          }),
      middle: Text("Notes"),
      leading: CupertinoButton(
          sizeStyle: CupertinoButtonSize.small,
          child: Icon(
            CupertinoIcons.settings,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pushNamed("/settingsPage")),
    ),
    child: Consumer<NoteTitlesModel>(
      builder: (context, value, child) {
        return SafeArea(
          child: value.value.isNotEmpty ? notesView() : noNotesView(context),
        );
      },
    ),
  );
}
