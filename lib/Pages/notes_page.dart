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
        Provider.of<IsLockedModel>(context, listen: false).updateSilently(true);
        Navigator.of(context).pushNamed("/notePage", arguments: {
          "noteID": key
        });
      },
    )),
  );
  return result;
}

Widget notesView(BuildContext context) {
  return ListView(
    children: [
      CupertinoListTile(title: CupertinoSearchTextField(
        onChanged: (value) {
          Provider.of<NoteTitlesModel>(context, listen: false).filterTitles(value);
        },
      )),
      Consumer<NoteTitlesModel>(
        builder: (context, value, child) {
          return CupertinoListSection(
            topMargin: 0,
            hasLeading: false,
            backgroundColor: CupertinoColors.systemBackground,
            children: value.value.isNotEmpty
                ? retrieveNoteWidgets(value.value, context)
                : [
                    SizedBox()
                  ],
          );
        },
      )
    ],
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
            Provider.of<IsLockedModel>(context, listen: false).updateSilently(false);
            Navigator.of(context).pushNamed("/notePage", arguments: {
              "noteID": null
            });
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
          child: (value.value.isNotEmpty || value.isFiltered) ? notesView(context) : noNotesView(context),
        );
      },
    ),
  );
}
