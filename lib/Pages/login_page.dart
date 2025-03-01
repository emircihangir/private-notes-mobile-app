import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:privatenotes/Pages/notes_page.dart';
import 'package:privatenotes/main.dart';

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
