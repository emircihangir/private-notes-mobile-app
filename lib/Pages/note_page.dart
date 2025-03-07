import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:privatenotes/main.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:provider/provider.dart';

class EyeValueModel extends ChangeNotifier {
  bool _isOpen = false;
  bool get isOpen => _isOpen;
  set isOpen(bool value) {
    _isOpen = value;
    notifyListeners();
  }

  void toggle() {
    _isOpen = !_isOpen;
    notifyListeners();
  }
}

Widget notePage(BuildContext context, {bool newNote = false}) {
  var titleTFcontroller = TextEditingController();
  var contentTFcontroller = TextEditingController();
  var passwordIC = TextEditingController(); // password input controller

  Future<void> createNewNote() async {
    //TODO: securely erase map and IC text variables.
    //TODO: reset the input values after finishing.
    Map<String, dynamic> notesFileData = json.decode(await notesFile.readAsString());
    String newNoteID = "note${cookiesData["totalNotes"] + 1}";
    cookiesData["totalNotes"] += 1;

    var encryptedContent = encrypt.Encrypter(encrypt.AES(encrypt.Key(Uint8List.fromList(sha256.convert(utf8.encode(passwordIC.text)).bytes)))).encrypt(contentTFcontroller.text, iv: encrypt.IV.allZerosOfLength(16)).base64;

    notesFileData["noteTitles"][newNoteID] = titleTFcontroller.text;
    notesFileData["noteContents"][newNoteID] = encryptedContent;

    // reset the input values.
    passwordIC.text = "";
    if (context.mounted && Provider.of<EyeValueModel>(context, listen: false).isOpen) Provider.of<EyeValueModel>(context, listen: false).toggle();

    // write to file
    await notesFile.writeAsString(json.encode(notesFileData));
    await cookiesFile.writeAsString(json.encode(cookiesData));

    // debugger();
  }

  return CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(
      leading: CupertinoButton(
          sizeStyle: CupertinoButtonSize.small,
          child: Icon(
            CupertinoIcons.checkmark,
            size: 24,
          ),
          onPressed: () async {
            showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: const Text("Enter Password"),
                  content: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Consumer<EyeValueModel>(
                              builder: (context, value, child) => CupertinoTextField(
                                placeholder: "Password",
                                autofocus: true,
                                obscureText: !(value.isOpen),
                                controller: passwordIC,
                              ),
                            ),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              Provider.of<EyeValueModel>(context, listen: false).toggle();
                            },
                            sizeStyle: CupertinoButtonSize.small,
                            child: Consumer<EyeValueModel>(
                              builder: (context, value, child) => Icon(
                                value.isOpen ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                                size: 24,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text("OK"),
                      onPressed: () async {
                        //TODO: validate the password

                        // disable the ok button until something is typed?

                        await createNewNote();
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                );
              },
            );
            // Navigator.of(context).pop();
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
              controller: titleTFcontroller,
              autofocus: newNote,
            ),
          ),
          Expanded(
            child: CupertinoListTile(
              title: Expanded(
                child: CupertinoTextField.borderless(
                  textAlignVertical: TextAlignVertical.top,
                  placeholder: "Note Content",
                  maxLines: null,
                  controller: contentTFcontroller,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
