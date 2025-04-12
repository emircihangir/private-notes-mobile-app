import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privatenotes/Pages/settings_page.dart';
import 'package:privatenotes/main.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:provider/provider.dart';

class ButtonEnabledModel extends ChangeNotifier {
  bool _unlockEnabled = false;
  bool get unlockEnabled => _unlockEnabled;
  set unlockEnabled(bool value) {
    _unlockEnabled = value;
    notifyListeners();
  }

  bool _okEnabled = false;
  bool get okEnabled => _okEnabled;
  set okEnabled(bool value) {
    _okEnabled = value;
    notifyListeners();
  }

  void resetSilently() => _unlockEnabled = _okEnabled = false;
}

class EyeValueModel extends ChangeNotifier {
  bool _cmEyeIsOpen = false; // the eye value of password input that opens after pressing checkmark
  bool get cmEyeIsOpen => _cmEyeIsOpen;
  set cmEyeIsOpen(bool value) {
    _cmEyeIsOpen = value;
    notifyListeners();
  }

  bool _uEyeIsOpen = false; // the eye value of the unlock note password input
  bool get uEyeIsOpen => _uEyeIsOpen;
  set uEyeIsOpen(bool value) {
    _uEyeIsOpen = value;
    notifyListeners();
  }

  void toggleCMeye() => cmEyeIsOpen = !cmEyeIsOpen;
  void toggleUeye() => uEyeIsOpen = !uEyeIsOpen;
}

class IsLockedModel extends ChangeNotifier {
  bool _isLocked = false;
  bool get isLocked => _isLocked;
  set isLocked(bool value) {
    _isLocked = value;
    notifyListeners();
  }

  void updateSilently(bool newValue) => _isLocked = newValue;
}

var piController = TextEditingController(); // pi = password input
var piFocusNode = FocusNode();
var titleTFcontroller = TextEditingController();
var contentTFcontroller = TextEditingController();
var passwordIC = TextEditingController(); // password input controller

Widget notePage(BuildContext context) {
  final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  String? noteID = args?["noteID"];
  if (noteID != null) {
    titleTFcontroller.text = notesFileData["noteTitles"][noteID];
  }

  SystemChannels.lifecycle.setMessageHandler((msg) async {
    if (msg == "AppLifecycleState.inactive" && context.mounted) {
      contentTFcontroller.text = "";
      Provider.of<IsLockedModel>(context, listen: false).isLocked = true;
      Provider.of<ButtonEnabledModel>(context, listen: false).resetSilently();
    }
    return null;
  });

  Future<void> createNewNote() async {
    String newNoteID = "note${cookiesFileData["totalNotes"] + 1}";
    cookiesFileData["totalNotes"] += 1;

    if (contentTFcontroller.text.isEmpty) contentTFcontroller.text = " ";

    var encryptedContent = encrypt.Encrypter(encrypt.AES(encrypt.Key(Uint8List.fromList(sha256.convert(utf8.encode(passwordIC.text)).bytes)))).encrypt(contentTFcontroller.text, iv: encrypt.IV.allZerosOfLength(16)).base64;
    notesFileData["noteContents"][newNoteID] = encryptedContent;

    notesFileData["noteTitles"][newNoteID] = titleTFcontroller.text;

    // reset the input values.
    passwordIC.text = "";
    if (Provider.of<EyeValueModel>(context, listen: false).cmEyeIsOpen) Provider.of<EyeValueModel>(context, listen: false).toggleCMeye();

    Provider.of<NoteTitlesModel>(context, listen: false).setValue(newNoteID, titleTFcontroller.text);

    // write to files
    await notesFile.writeAsString(json.encode(notesFileData));
    await cookiesFile.writeAsString(json.encode(cookiesFileData));
  }

  void saveNote() async {
    if (noteID == null) {
      await createNewNote();
    } else {
      if (contentTFcontroller.text.isEmpty) contentTFcontroller.text = " ";

      var encryptedContent = encrypt.Encrypter(encrypt.AES(encrypt.Key(Uint8List.fromList(sha256.convert(utf8.encode(passwordIC.text)).bytes)))).encrypt(contentTFcontroller.text, iv: encrypt.IV.allZerosOfLength(16)).base64;
      notesFileData["noteContents"][noteID] = encryptedContent;

      notesFileData["noteTitles"][noteID] = titleTFcontroller.text;

      if (Provider.of<EyeValueModel>(context, listen: false).cmEyeIsOpen) Provider.of<EyeValueModel>(context, listen: false).toggleCMeye();

      Provider.of<NoteTitlesModel>(context, listen: false).setValue(noteID, titleTFcontroller.text);

      // write to file
      await notesFile.writeAsString(json.encode(notesFileData));
    }
    if (cookiesFileData["autoExportEnabled"]) await exportNotes(provideFeedback: false);

    // reset the input values.
    passwordIC.text = "";
    titleTFcontroller.text = "";
    piController.text = "";
    contentTFcontroller.text = "";

    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void unlockPressed(BuildContext context) {
    try {
      contentTFcontroller.text = encrypt.Encrypter(encrypt.AES(encrypt.Key(Uint8List.fromList(sha256.convert(utf8.encode(piController.text)).bytes)))).decrypt64(notesFileData["noteContents"][noteID], iv: encrypt.IV.allZerosOfLength(16));
      if (contentTFcontroller.text == " ") contentTFcontroller.text = "";
      piController.text = "";
      // Provider.of<ButtonEnabledModel>(context).unlockEnabled = false;
    } on ArgumentError {
      showCupertinoDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Password is wrong"),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }
    Provider.of<IsLockedModel>(context, listen: false).isLocked = false;
  }

  void deleteNote() async {
    notesFileData["noteTitles"].remove(noteID);
    notesFileData["noteContents"].remove(noteID);
    cookiesFileData["totalNotes"] -= 1;
    Provider.of<NoteTitlesModel>(context, listen: false).removeValue(noteID!);

    // write to files
    await notesFile.writeAsString(json.encode(notesFileData));
    await cookiesFile.writeAsString(json.encode(cookiesFileData));

    if (cookiesFileData["autoExportEnabled"]) await exportNotes(provideFeedback: false);

    // reset the input values.
    passwordIC.text = "";
    titleTFcontroller.text = "";
    piController.text = "";
    contentTFcontroller.text = "";
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Provider.of<ButtonEnabledModel>(context, listen: false).resetSilently();

  return CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(
      leading: Consumer<IsLockedModel>(
        builder: (context, value, child) {
          return value.isLocked == false
              ? CupertinoButton(
                  sizeStyle: CupertinoButtonSize.small,
                  onPressed: () {
                    // debugger();
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: const Text("Enter Password"),
                          content: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text("Enter the password to lock this note with."),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Consumer<EyeValueModel>(
                                      builder: (context, value, child) {
                                        return CupertinoTextField(
                                          placeholder: "Password",
                                          autofocus: true,
                                          obscureText: !(value.cmEyeIsOpen),
                                          controller: passwordIC,
                                          onChanged: (value) => Provider.of<ButtonEnabledModel>(context, listen: false).okEnabled = (value.isNotEmpty),
                                        );
                                      },
                                    ),
                                  ),
                                  CupertinoButton(
                                    onPressed: () {
                                      Provider.of<EyeValueModel>(context, listen: false).toggleCMeye();
                                    },
                                    sizeStyle: CupertinoButtonSize.small,
                                    child: Consumer<EyeValueModel>(
                                      builder: (context, value, child) {
                                        return Icon(
                                          value.cmEyeIsOpen ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                                          size: 24,
                                        );
                                      },
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
                            Consumer<ButtonEnabledModel>(
                              builder: (context, value, child) => CupertinoDialogAction(
                                onPressed: value.okEnabled ? saveNote : null,
                                child: const Text("OK"),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(CupertinoIcons.checkmark, size: 24),
                )
              : CupertinoButton(
                  sizeStyle: CupertinoButtonSize.small,
                  onPressed: () {
                    // reset the input values.
                    passwordIC.text = "";
                    titleTFcontroller.text = "";
                    piController.text = "";
                    contentTFcontroller.text = "";
                    Navigator.of(context).pop();
                  },
                  child: Icon(CupertinoIcons.back, size: 24),
                );
        },
      ),
      middle: Text("Note"),
      trailing: Consumer<IsLockedModel>(
        builder: (context, value, child) {
          return value.isLocked == false
              ? CupertinoButton(
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
                        content: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: const Text("This action is irreversible."),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: deleteNote,
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );
                  })
              : SizedBox();
        },
      ),
    ),
    child: SafeArea(
      child: Column(
        children: [
          Consumer<IsLockedModel>(
            builder: (context, value, child) {
              return CupertinoListTile(
                title: CupertinoTextField.borderless(
                  style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                  placeholder: "Note Title",
                  controller: titleTFcontroller,
                  autofocus: (noteID == null),
                  readOnly: value.isLocked,
                ),
              );
            },
          ),
          Consumer<IsLockedModel>(
            builder: (context, value, child) {
              return Expanded(
                child: value.isLocked
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/locked.svg",
                            width: 70,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Locked",
                            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 48,
                              ),
                              SizedBox(
                                width: 150,
                                child: Consumer<EyeValueModel>(
                                  builder: (context, value, child) {
                                    return CupertinoTextField(
                                      placeholder: "Password",
                                      textAlign: TextAlign.center,
                                      focusNode: piFocusNode,
                                      controller: piController,
                                      obscureText: !value.uEyeIsOpen,
                                      autofocus: true,
                                      onChanged: (value) => Provider.of<ButtonEnabledModel>(context, listen: false).unlockEnabled = (value.isNotEmpty),
                                    );
                                  },
                                ),
                              ),
                              CupertinoButton(
                                onPressed: () {
                                  Provider.of<EyeValueModel>(context, listen: false).toggleUeye();
                                },
                                sizeStyle: CupertinoButtonSize.small,
                                child: Consumer<EyeValueModel>(
                                  builder: (context, value, child) {
                                    return Icon(
                                      value.uEyeIsOpen ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                                      size: 24,
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                          Consumer<ButtonEnabledModel>(
                            builder: (context, value, child) => CupertinoButton(onPressed: (value.unlockEnabled) ? () => unlockPressed(context) : null, child: Text("Unlock")),
                          )
                        ],
                      )
                    : CupertinoListTile(
                        title: Expanded(
                          child: CupertinoTextField.borderless(
                            textAlignVertical: TextAlignVertical.top,
                            placeholder: "Note Content",
                            maxLines: null,
                            controller: contentTFcontroller,
                          ),
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
