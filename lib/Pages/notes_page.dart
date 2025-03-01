import 'package:flutter/cupertino.dart';
import 'package:privatenotes/Pages/login_page.dart';
import 'package:privatenotes/Pages/note_page.dart';
import 'package:privatenotes/Views/no_notes_view.dart';
import 'package:privatenotes/Views/settings_modal.dart';

Widget notesPage(BuildContext context) {
  return CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(
      leading: CupertinoButton(
          sizeStyle: CupertinoButtonSize.small,
          child: Icon(
            CupertinoIcons.lock,
            size: 24,
          ),
          onPressed: () {
            //TODO: Encrypt the notes before leaving.
            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return loginPage(context);
                },
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);
                  return FadeTransition(opacity: fadeAnimation, child: child);
                },
              ),
              (Route<dynamic> route) => false,
            );
          }),
      middle: Text("Notes"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
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
          CupertinoButton(
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
        ],
      ),
    ),
    child: SafeArea(child: noNotesView(context)),
  );
}
