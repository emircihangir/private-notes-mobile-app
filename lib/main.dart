import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './disclaimer.dart';
import 'package:provider/provider.dart';

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
        theme: CupertinoThemeData(textTheme: CupertinoTextThemeData(textStyle: TextStyle(fontFamily: "SFpro", color: CupertinoColors.black))),
        home: CupertinoPageScaffold(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: welcomeView(context),
            ),
          ),
        ),
      ),
    );
  }
}

Widget welcomeView(BuildContext context) {
  var pageController = PageController(initialPage: 2);

  Widget slide1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage("assets/private-notes-icon.png"),
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


Widget notesPage(BuildContext context) {
  return CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(
      leading: CupertinoButton(
          sizeStyle: CupertinoButtonSize.small,
          child: Icon(
            CupertinoIcons.escape,
            size: 24,
          ),
          onPressed: () {}),
      middle: Text("Notes"),
      trailing: CupertinoButton(
          sizeStyle: CupertinoButtonSize.small,
          child: Icon(
            CupertinoIcons.text_badge_plus,
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => notePage(context),
            ));
          }),
    ),
    child: SafeArea(child: dummyNotesView(context)),
  );
}


Widget noNotesView(BuildContext context) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("No notes. Tap "),
        Icon(
          CupertinoIcons.text_badge_plus,
          size: 24,
          color: CupertinoColors.systemGrey,
        ),
        Text(" to create a new one.")
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
