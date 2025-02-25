import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './disclaimer.dart';

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
            child: welcomeView(context),
          ),
        ),
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
          onPressed: () {
            pageController.nextPage(duration: Durations.long1, curve: Curves.ease);
          },
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
        Text(disclaimerText)
      ],
    );
  }

  return PageView(
    physics: NeverScrollableScrollPhysics(),
    controller: pageController,
    children: [
      slide1(),
      slide2(),
      Placeholder(
        child: Center(
          child: Text("Slide 3"),
        ),
      ),
    ],
  );
}
