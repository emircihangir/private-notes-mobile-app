import 'dart:convert';
import 'dart:developer';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:privatenotes/main.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class AEswitchModel extends ChangeNotifier {
  bool _switchValue;
  AEswitchModel({required bool initialValue}) : _switchValue = initialValue;
  bool get switchValue => _switchValue;
  set switchValue(bool value) {
    _switchValue = value;
    notifyListeners();
  }
}

Future<void> _launchUrl(Uri url) async {
  if (!(await launchUrl(url))) {
    throw Exception('Could not launch $url');
  }
}

Future<void> exportNotes({bool provideFeedback = true}) async {
  String formattedDate = DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now());
  var exportFileName = "private-notes-export-$formattedDate";

  const MethodChannel mc = MethodChannel("com.example.save_to_downloads");
  bool result = await mc.invokeMethod("saveToDownloads", {
    "content": json.encode(notesFileData),
    "fileName": exportFileName,
    "mimeType": "application/json"
  });

  if (provideFeedback == false) return;

  if (result == true) {
    showCupertinoDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Export Successful"),
        content: const Text("The export file is in the Downloads folder."),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  } else {
    showCupertinoDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Export Failed"),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

Widget settingsPage(BuildContext context) {
  Future<void> importNotes(Map<String, dynamic> importFileData) async {
    if (importFileData["noteTitles"] == null || importFileData["noteContents"]) {
      showCupertinoDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Import failed"),
          content: const Text("The selected file has the wrong format. See the documentation for more info."),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    int totalNotesImage = cookiesFileData["totalNotes"];
    for (MapEntry entry in importFileData["noteTitles"].entries) {
      String newNoteID = "note${totalNotesImage + 1}";
      notesFileData["noteTitles"][newNoteID] = entry.value;
      totalNotesImage += 1;
      Provider.of<NoteTitlesModel>(context, listen: false).setValue(newNoteID, entry.value, silent: !(entry == importFileData["noteTitles"].entries.last));
    }

    totalNotesImage = cookiesFileData["totalNotes"];

    for (MapEntry entry in importFileData["noteContents"].entries) {
      String newNoteID = "note${totalNotesImage + 1}";
      notesFileData["noteContents"][newNoteID] = entry.value;
      totalNotesImage += 1;
    }

    cookiesFileData["totalNotes"] = totalNotesImage;

    Navigator.of(context).pushNamedAndRemoveUntil(
      "/notesPage",
      (route) => false,
    );

    await notesFile.writeAsString(json.encode(notesFileData));
    await cookiesFile.writeAsString(json.encode(cookiesFileData));
  }

  Future<void> selectFile() async {
    final XFile? file = await openFile(acceptedTypeGroups: [
      XTypeGroup(label: "JSON", extensions: [
        "json"
      ])
    ]);

    if (file != null) {
      var _jsonDecoded;
      try {
        _jsonDecoded = json.decode(await file.readAsString());
      } catch (e) {
        showCupertinoDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Import failed"),
            content: const Text("The selected file is corrupt. See the documentation for more info."),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
        return;
      }

      await importNotes(_jsonDecoded);
    }
  }

  return CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(
      leading: CupertinoButton(
        sizeStyle: CupertinoButtonSize.small,
        onPressed: () => Navigator.of(context).pop(),
        child: Icon(CupertinoIcons.back, size: 24),
      ),
      middle: const Text("Settings & Help"),
    ),
    child: SafeArea(
      child: Container(
        color: CupertinoColors.systemGroupedBackground,
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              header: Text("Settings"),
              hasLeading: false,
              children: [
                CupertinoListTile.notched(
                  title: const Text(
                    "Export Notes",
                    style: TextStyle(color: CupertinoColors.systemBlue),
                  ),
                  onTap: exportNotes,
                ),
                CupertinoListTile.notched(
                  title: const Text(
                    "Import Notes",
                    style: TextStyle(color: CupertinoColors.systemBlue),
                  ),
                  onTap: selectFile,
                ),
                CupertinoListTile.notched(
                  title: const Text("Auto-Export"),
                  trailing: Consumer<AEswitchModel>(
                    builder: (context, value, child) {
                      return CupertinoSwitch(
                        value: value.switchValue,
                        onChanged: (newValue) async {
                          Provider.of<AEswitchModel>(context, listen: false).switchValue = newValue;
                          cookiesFileData["autoExportEnabled"] = newValue;
                          await cookiesFile.writeAsString(json.encode(cookiesFileData));
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text("Developer"),
              hasLeading: false,
              children: [
                CupertinoListTile.notched(
                  title: Text("Name"),
                  trailing: Text("Emir Cihangir"),
                ),
                CupertinoListTile.notched(
                  title: Text("Email"),
                  onTap: () {
                    _launchUrl(Uri.parse("mailto:m.emircihangir@gmail.com"));
                  },
                  trailing: Text(
                    "m.emircihangir@gmail.com 􀉣",
                    style: TextStyle(color: CupertinoColors.systemBlue),
                  ),
                ),
                CupertinoListTile.notched(
                  title: Text("Website"),
                  onTap: () => _launchUrl(Uri.parse("https://www.emircihangir.com")),
                  trailing: Text(
                    "emircihangir.com 􀉣",
                    style: TextStyle(color: CupertinoColors.systemBlue),
                  ),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text("App"),
              hasLeading: false,
              children: [
                CupertinoListTile.notched(
                  title: Text("Release Date"),
                  //TODO: Write the date
                  trailing: Text("..."),
                ),
                CupertinoListTile.notched(
                  title: Text("Version"),
                  trailing: Text("1.0"),
                ),
                CupertinoListTile.notched(
                  title: Text("Source Code"),
                  trailing: Text(
                    "GitHub 􀉣",
                    style: TextStyle(color: CupertinoColors.systemBlue),
                  ),
                  onTap: () => _launchUrl(Uri.parse("https://github.com/emircihangir/private-notes-mobile-app")),
                ),
                CupertinoListTile.notched(
                  title: Text("FAQ"),
                  trailing: CupertinoListTileChevron(),
                  onTap: () {},
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
