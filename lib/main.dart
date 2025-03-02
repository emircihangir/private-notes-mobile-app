import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:privatenotes/Pages/login_page.dart';
import 'package:privatenotes/Pages/notes_page.dart';
import 'package:privatenotes/Views/welcome_view.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Uint8List? digestBytes;
File? cookiesFile;

class DisclaimerCBModel extends ChangeNotifier {
  bool? _value = false;
  bool? get value => _value;
  set value(bool? value) {
    _value = value;
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

  // create the necessary files if they do not exists.
  final directory = await getApplicationDocumentsDirectory();
  final notesFilePath = "${directory.path}/notes.json";
  final cookiesFilePath = "${directory.path}/cookies.json";
  File notesFile = File(notesFilePath);
  cookiesFile = File(cookiesFilePath);

  if (await notesFile.exists() == false) {
    // create the notes file.
    Map<String, dynamic> notesFileData = {
      "notes": {}
    };
    final notesFileDataJSON = json.encode(notesFileData);
    await notesFile.writeAsString(notesFileDataJSON);
    print("notes.json successfully created.");
  }
  if (await cookiesFile!.exists() == false) {
    // create the cookies file.
    Map<String, dynamic> cookiesFileData = {
      "totalNotes": 0
    };
    final cookiesFileDataJSON = json.encode(cookiesFileData);
    await cookiesFile!.writeAsString(cookiesFileDataJSON);
    print("cookies.json successfully created.");
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
          create: (context) => DisclaimerCBModel(),
        )
      ],
      builder: (context, child) => CupertinoApp(
        routes: {
          "/": (BuildContext context) => welcomeView(context),
          "/loginPage": (BuildContext context) => loginPage(context),
          "/notesPage": (BuildContext context) => notesPage(context),
        },
        navigatorKey: navigatorKey,
        theme: CupertinoThemeData(textTheme: CupertinoTextThemeData(textStyle: TextStyle(fontFamily: "SFpro", color: CupertinoColors.black)), brightness: Brightness.light),
      ),
    );
  }
}
