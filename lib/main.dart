import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:privatenotes/Pages/login_page.dart';
import 'package:privatenotes/Pages/note_page.dart';
import 'package:privatenotes/Pages/notes_page.dart';
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
  final Map<dynamic, dynamic> _value;
  NoteTitlesModel({required Map<dynamic, dynamic> initialValue}) : _value = initialValue;
  Map<dynamic, dynamic> get value => _value;
  void updateValue(String key, dynamic newValue) {
    _value[key] = newValue;
    notifyListeners();
  }

  void removeValue(String key) {
    _value.remove(key);
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
  final notesFilePath = "${directory.path}/notes";
  final cookiesFilePath = "${directory.path}/cookies";
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
      "totalNotes": 0
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
        ChangeNotifierProvider(
          create: (context) => DisclaimerCBVModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => EyeValueModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => NoteTitlesModel(initialValue: notesFileData["noteTitles"] ?? {}),
        ),
        ChangeNotifierProvider(
          create: (context) => IsLockedModel(),
        )
      ],
      builder: (context, child) {
        return CupertinoApp(
          routes: {
            "/": (BuildContext context) {
              if (firstTimeUser) {
                return welcomeView(context);
              } else {
                return notesPage(context);
              }
            },
            "/loginPage": (BuildContext context) => loginPage(context),
            "/notesPage": (BuildContext context) => notesPage(context),
          },
          navigatorKey: navigatorKey,
          theme: CupertinoThemeData(textTheme: CupertinoTextThemeData(textStyle: TextStyle(fontFamily: "SFpro", color: CupertinoColors.black)), brightness: Brightness.light),
        );
      },
    );
  }
}
