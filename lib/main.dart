import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:privatenotes/Pages/login_page.dart';
import 'package:privatenotes/Pages/note_page.dart';
import 'package:privatenotes/Pages/notes_page.dart';
import 'package:privatenotes/Pages/settings_page.dart';
import 'package:privatenotes/Views/welcome_view.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

File cookiesFile = File("");
File notesFile = File("");
bool firstTimeUser = true;
Map<String, dynamic> cookiesFileData = {};
Map<String, dynamic> notesFileData = {};

//** Disclaimer checkbox value model */
class DisclaimerCBVModel extends ChangeNotifier {
  bool? _value = false;
  bool? get value => _value;
  set value(bool? value) {
    _value = value;
    notifyListeners();
  }
}

class NoteTitlesModel extends ChangeNotifier {
  Map<dynamic, dynamic> _value;
  bool isFiltered = false;
  NoteTitlesModel({required Map<dynamic, dynamic> initialValue}) : _value = initialValue;
  Map<dynamic, dynamic> get value => _value;
  void setValue(String key, dynamic newValue, {bool silent = false}) {
    _value[key] = newValue;
    if (silent == false) notifyListeners();
  }

  void removeValue(String key) {
    _value.remove(key);
    notifyListeners();
  }

  void filterTitles(String text) {
    if (text.isNotEmpty) {
      isFiltered = true;
    } else {
      isFiltered = false;
    }
    _value = Map.fromEntries(notesFileData["noteTitles"].entries.where((entry) => entry.value.toString().contains(text)));
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: CupertinoColors.systemBackground,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // determine if it's a first-time user and initialize the global variables.
  final directory = await getApplicationDocumentsDirectory();
  final notesFilePath = "${directory.path}/notes.json";
  final cookiesFilePath = "${directory.path}/cookies.json";
  notesFile = File(notesFilePath);
  cookiesFile = File(cookiesFilePath);
  bool cookiesFileExists = await cookiesFile.exists();
  if (cookiesFileExists) {
    firstTimeUser = false;
    final cookiesFileContent = await cookiesFile.readAsString();
    cookiesFileData = json.decode(cookiesFileContent);
    notesFileData = json.decode(await notesFile.readAsString());
  } else {
    notesFileData = {
      "noteTitles": {},
      "noteContents": {}
    };

    cookiesFileData = {
      "totalNotes": 0,
      "autoExportEnabled": true
    };
  }

  runApp(const PrivateNotesApp());
}

class PrivateNotesApp extends StatelessWidget {
  const PrivateNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DisclaimerCBVModel()),
        ChangeNotifierProvider(create: (context) => EyeValueModel()),
        ChangeNotifierProvider(create: (context) => NoteTitlesModel(initialValue: notesFileData["noteTitles"] ?? {})),
        ChangeNotifierProvider(create: (context) => IsLockedModel()),
        ChangeNotifierProvider(create: (context) => AEswitchModel(initialValue: cookiesFileData["autoExportEnabled"])),
        ChangeNotifierProvider(
          create: (context) => ButtonEnabledModel(),
        )
      ],
      builder: (context, child) {
        return CupertinoApp(
          routes: {
            "/": (BuildContext context) => firstTimeUser ? welcomeView(context) : notesPage(context),
            "/loginPage": (BuildContext context) => loginPage(context),
            "/notesPage": (BuildContext context) => notesPage(context),
            "/notePage": (BuildContext context) => notePage(context),
            "/settingsPage": (BuildContext context) => settingsPage(context)
          },
          navigatorKey: navigatorKey,
          theme: CupertinoThemeData(textTheme: CupertinoTextThemeData(textStyle: TextStyle(fontFamily: "SFpro", color: CupertinoColors.black)), brightness: Brightness.light),
        );
      },
    );
  }
}
