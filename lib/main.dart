import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privatenotes/Pages/login_page.dart';
import 'package:privatenotes/Pages/note_page.dart';
import 'package:privatenotes/Pages/notes_page.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DisclaimerCBModel extends ChangeNotifier {
  bool? _value = false;
  bool? get value => _value;
  set value(bool? value) {
    _value = value;
    notifyListeners();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, systemNavigationBarColor: CupertinoColors.systemBackground, systemNavigationBarIconBrightness: Brightness.dark));
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
          "/": (BuildContext context) => notesPage(context),
          "/loginPage": (BuildContext context) => loginPage(context),
          "/notesPage": (BuildContext context) => notesPage(context),
        },
        navigatorKey: navigatorKey,
        theme: CupertinoThemeData(textTheme: CupertinoTextThemeData(textStyle: TextStyle(fontFamily: "SFpro", color: CupertinoColors.black)), brightness: Brightness.light),
      ),
    );
  }
}

void createNewNote(BuildContext context) {
  Navigator.of(context).push(CupertinoPageRoute(
    builder: (context) => notePage(context),
  ));
}

//TODO: delete this before production.
Widget dummyNotesView(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      children: [
        CupertinoListTile(title: CupertinoSearchTextField()),
        CupertinoListSection(
          topMargin: 0,
          hasLeading: false,
          backgroundColor: CupertinoColors.systemBackground,
          children: [
            CupertinoListTile(
              title: Text("note 1"),
              subtitle: Text("note 1 subtitle"),
              onTap: () {},
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
            CupertinoListTile(
              title: Text("note 2"),
              subtitle: Text("note 2 subtitle"),
            ),
          ],
        ),
      ],
    ),
  );
}
