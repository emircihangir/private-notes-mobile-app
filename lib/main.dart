import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          "/": (BuildContext context) => welcomeView(context),
          "/loginPage": (BuildContext context) => loginPage(context),
          "/notesPage": (BuildContext context) => notesPage(context)
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

              //TODO: Create the password efore navigating.
              Navigator.of(context).pushNamed("/notesPage");
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

Widget notesPage(BuildContext context) {
  return CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(
      leading: CupertinoButton(
          sizeStyle: CupertinoButtonSize.small,
          child: Icon(
            CupertinoIcons.lock,
            size: 24,
          ),
          onPressed: () {
            //TODO: Encrypt the notes before leaving.
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return loginPage(context);
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);
                return FadeTransition(opacity: fadeAnimation, child: child);
              },
            ));
          }),
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
    child: SafeArea(child: noNotesView(context)),
  );
}

Widget notePage(BuildContext context) {
  return CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(
      leading: CupertinoButton(
          sizeStyle: CupertinoButtonSize.small,
          child: Icon(
            CupertinoIcons.back,
            size: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
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
            ),
          ),
          Expanded(
            child: CupertinoListTile(
              title: Expanded(
                child: CupertinoTextField.borderless(
                  textAlignVertical: TextAlignVertical.top,
                  placeholder: "Note Content",
                  maxLines: null,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
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

Widget loginPage(BuildContext context) {
  var piController = TextEditingController(); // pi = password input
  var piFocusNode = FocusNode();

  return CupertinoPageScaffold(
    child: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/private-notes-icon.svg",
              width: 150,
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
            SizedBox(
              width: 250,
              child: Text(
                "Notes are locked. Please enter the password to unlock them.",
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 250,
              child: CupertinoTextField(
                placeholder: "Password",
                focusNode: piFocusNode,
                controller: piController,
                obscureText: true,
              ),
            ),
            CupertinoButton(
                child: Text("Unlock"),
                onPressed: () {
                  if (piController.text.isEmpty) {
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
                  piController.text = "";
                  piFocusNode.unfocus();

                  //TODO: check if the password is correct before navigating
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => notesPage(context),
                  ));
                })
          ],
        ),
      ),
    ),
  );
}
