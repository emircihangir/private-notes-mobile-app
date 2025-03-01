import 'package:flutter/cupertino.dart';
import 'package:privatenotes/main.dart';

Widget notePage(BuildContext context) {
  return CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(
      leading: CupertinoButton(
          sizeStyle: CupertinoButtonSize.small,
          child: Icon(
            CupertinoIcons.back,
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      middle: Text("Note"),
      trailing: CupertinoButton(
          sizeStyle: CupertinoButtonSize.small,
          child: Icon(
            CupertinoIcons.delete,
            color: CupertinoColors.destructiveRed,
            size: 24,
          ),
          onPressed: () {
            showCupertinoDialog(
              context: navigatorKey.currentContext!,
              builder: (context) => CupertinoAlertDialog(
                title: const Text("Are you sure?"),
                content: const Text("This action is irreversible."),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {},
                    child: const Text("Delete"),
                  ),
                ],
              ),
            );
          }),
    ),
    child: SafeArea(
      child: Column(
        children: [
          CupertinoListTile(
            title: CupertinoTextField.borderless(
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              placeholder: "Note Title",
            ),
          ),
          Expanded(
            child: CupertinoListTile(
              title: Expanded(
                child: CupertinoTextField.borderless(
                  textAlignVertical: TextAlignVertical.top,
                  placeholder: "Note Content",
                  maxLines: null,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
