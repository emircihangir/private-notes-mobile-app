import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const PrivateNotesApp());
}

class PrivateNotesApp extends StatelessWidget {
  const PrivateNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(textTheme: CupertinoTextThemeData(textStyle: TextStyle(fontFamily: "SFpro", color: CupertinoColors.black))),
      home: CupertinoPageScaffold(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.00),
            child: welcomeView(),
          ),
        ),
      ),
    );
  }
}

Widget welcomeView() {
  var pageController = PageController(initialPage: 0);
  return PageView(
    controller: pageController,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("assets/private-notes-icon.png"),
            width: 200,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Welcome to Private Notes.",
            style: TextStyle(fontSize: 24),
          ),
          CupertinoButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Let's get started "),
                Icon(CupertinoIcons.arrow_right)
              ],
            ),
            onPressed: () {
              pageController.nextPage(duration: Durations.long1, curve: Curves.ease);
            },
          )
        ],
      ),
      Placeholder(
        child: Center(
          child: Text("Slide 2"),
        ),
      ),
      Placeholder(
        child: Center(
          child: Text("Slide 3"),
        ),
      ),
    ],
  );
}
