import 'package:flutter/cupertino.dart';
import 'package:privatenotes/Pages/note_page.dart';
import 'package:privatenotes/Views/no_notes_view.dart';
import 'package:privatenotes/Views/settings_modal.dart';
import 'package:privatenotes/main.dart';
import 'package:provider/provider.dart';

Widget notesPage(BuildContext context) {
  List<Widget> retrieveNoteWidgets(Map<String, dynamic> data) {
    List<Widget> result = [];
    data.forEach(
      (key, value) => result.add(CupertinoListTile(
        title: Text(value),
        onTap: () {
          print(key);
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
            builder: (context, value, child) => CupertinoListSection(
              topMargin: 0,
              hasLeading: false,
              backgroundColor: CupertinoColors.systemBackground,
              children: retrieveNoteWidgets(value.value),
            ),
          )
        ],
      ),
    );
  }

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
              builder: (context) => notePage(context, newNote: true),
            ));
          }),
      middle: Text("Notes"),
      leading: CupertinoButton(
          sizeStyle: CupertinoButtonSize.small,
          child: Icon(
            CupertinoIcons.ellipsis_circle,
            size: 24,
          ),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) => settingsModal(),
            );
          }),
    ),
    child: Consumer<NoteTitlesModel>(
      builder: (context, value, child) => SafeArea(
        child: value.value.isNotEmpty ? notesView() : noNotesView(context),
      ),
    ),
  );
}
