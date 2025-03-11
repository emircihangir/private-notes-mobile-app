import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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

Future<void> exportNotes() async {
  String formattedDate = DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now());
  var exportFileName = "private-notes-export-$formattedDate";

  const MethodChannel mc = MethodChannel("com.example.save_to_downloads");
  bool result = await mc.invokeMethod("saveToDownloads", {
    "content": json.encode(notesFileData),
    "fileName": exportFileName,
    "mimeType": "application/json"
  });

  result
      ? showCupertinoDialog(
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
        )
      : showCupertinoDialog(
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

Widget settingsPage(BuildContext context) {
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
                  onTap: () {},
                ),
                CupertinoListTile.notched(
                  title: const Text("Auto-Export"),
                  trailing: Consumer<AEswitchModel>(
                    builder: (context, value, child) {
                      return CupertinoSwitch(
                        value: value.switchValue,
                        onChanged: (newValue) {
                          //TODO: handle change event
                          Provider.of<AEswitchModel>(context, listen: false).switchValue = newValue;
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
