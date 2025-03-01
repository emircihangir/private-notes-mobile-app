import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privatenotes/Pages/login_page.dart';
import 'package:privatenotes/Pages/note_page.dart';
import 'package:privatenotes/Pages/notes_page.dart';
import './disclaimer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

Widget welcomeView(BuildContext context) {
  var pageController = PageController(initialPage: 0);

  Widget slide1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/private-notes-icon.svg",
          width: 150,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          "Welcome to Private Notes.",
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
        CupertinoButton(
          child: Text(
            "Let's get started ",
            style: CupertinoTheme.of(context).textTheme.actionSmallTextStyle,
          ),
          onPressed: () => pageController.nextPage(duration: Durations.long1, curve: Curves.ease),
        )
      ],
    );
  }

  Widget slide2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Disclaimer",
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          disclaimerText,
          textAlign: TextAlign.justify,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<DisclaimerCBModel>(
              builder: (context, cbValue, child) => CupertinoCheckbox(
                value: cbValue.value,
                onChanged: (value) => Provider.of<DisclaimerCBModel>(context, listen: false).value = value,
                semanticLabel: "I have read and understand the terms.",
              ),
            ),
            Text(
              "I have read and understand the terms.",
            )
          ],
        ),
        Consumer<DisclaimerCBModel>(
          builder: (context, value, child) => CupertinoButton(
            onPressed: value.value == true ? () => pageController.nextPage(duration: Durations.long1, curve: Curves.ease) : null,
            sizeStyle: CupertinoButtonSize.small,
            child: const Text("Continue"),
          ),
        )
      ],
    );
  }

  Widget slide3() {
    var mpiController = TextEditingController(); // mpi = master password input
    var mpiFocusNode = FocusNode();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/key.svg",
          width: 70,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          "Master Password",
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 250,
          child: Text(
            "Create the master password to be used for encryption / decryption. Make sure it's strong and hard to predict. Saving this password anywhere is not recommended.",
            textAlign: TextAlign.justify,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 250,
          child: CupertinoTextField(
            placeholder: "Master Password",
            focusNode: mpiFocusNode,
            controller: mpiController,
          ),
        ),
        CupertinoButton(
            child: Text("Create"),
            onPressed: () {
              if (mpiController.text.isEmpty) {
                showCupertinoDialog(
                  context: navigatorKey.currentContext!,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text("Enter a password"),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      )
                    ],
                  ),
                );
                return;
              }
              mpiController.text = "";
              mpiFocusNode.unfocus();

              //TODO: Create the password before navigating.
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/notesPage",
                (Route<dynamic> route) => false,
              );
            })
      ],
    );
  }

  return CupertinoPageScaffold(
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            slide1(),
            slide2(),
            slide3()
          ],
        ),
      ),
    ),
  );
}

void createNewNote(BuildContext context) {
  Navigator.of(context).push(CupertinoPageRoute(
    builder: (context) => notePage(context),
  ));
}

Widget noNotesView(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("No notes. Tap below to create a new one."),
        CupertinoButton(
          child: Text("New Note"),
          onPressed: () => createNewNote(context),
        )
      ],
    ),
  );
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
