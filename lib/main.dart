import 'package:flutter/cupertino.dart';

void main() {
  runApp(const AndroidApp());
}

class AndroidApp extends StatelessWidget {
  const AndroidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        child: SafeArea(
          child: loginPage(),
        ),
      ),
    );
  }
}

Widget loginPage() {
  return Placeholder();
}
