import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privatenotes/disclaimer.dart';
import 'package:privatenotes/main.dart';
import 'package:provider/provider.dart';

Widget welcomeView(BuildContext context) {
  var pageController = PageController(initialPage: 2);

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
    var piController = TextEditingController(); // pi = password input
    var piFocusNode = FocusNode();
    var piController2 = TextEditingController();
    var piFocusNode2 = FocusNode();

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
          "Password",
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 250,
          child: Text(
            "Create the password to lock your notes. Make sure it's strong and hard to predict. Saving this password anywhere is not recommended.",
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
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 250,
          child: CupertinoTextField(
            placeholder: "Confirm Password",
            focusNode: piFocusNode2,
            controller: piController2,
            obscureText: true,
          ),
        ),
        CupertinoButton(
            child: Text("Create"),
            onPressed: () {
              //TODO: check if the password inputs match
              if (piController.text.isEmpty || piController2.text.isEmpty) {
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
              } else if (piController.text != piController2.text) {
                showCupertinoDialog(
                  context: navigatorKey.currentContext!,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text("Passwords do not match"),
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
              piController2.text = "";
              piFocusNode2.unfocus();

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
