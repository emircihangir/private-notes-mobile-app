import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privatenotes/disclaimer.dart';
import 'package:privatenotes/how_to_text.dart';
import 'package:privatenotes/main.dart';
import 'package:provider/provider.dart';

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
            Consumer<DisclaimerCBVModel>(
              builder: (context, cbValue, child) => CupertinoCheckbox(
                value: cbValue.value,
                onChanged: (value) => Provider.of<DisclaimerCBVModel>(context, listen: false).value = value,
                semanticLabel: "I have read and understand the terms.",
              ),
            ),
            Text(
              "I have read and understand the terms.",
            )
          ],
        ),
        Consumer<DisclaimerCBVModel>(
          builder: (context, value, child) => CupertinoButton(
            // pageController.nextPage(duration: Durations.long1, curve: Curves.ease)
            onPressed: value.value == true ? () => pageController.nextPage(duration: Durations.long1, curve: Curves.ease) : null,
            sizeStyle: CupertinoButtonSize.small,
            child: const Text("Continue"),
          ),
        )
      ],
    );
  }

  Widget slide3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "How to use the app",
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          howToText,
          textAlign: TextAlign.justify,
        ),
        CupertinoButton(
            child: Text("Proceed"),
            onPressed: () async {
              // create the notes file
              Map<String, dynamic> notesFileData = {
                "noteTitles": {},
                "noteContents": {}
              };

              Map<String, dynamic> cfd = {
                "totalNotes": 0
              };

              await notesFile.writeAsString(json.encode(notesFileData));
              await cookiesFile.writeAsString(json.encode(cfd));

              if (context.mounted) Navigator.of(context).pushNamed("/notesPage");
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
