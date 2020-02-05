import 'package:flutter/material.dart';
import 'package:hutano/screens/demo_screen.dart';
import 'package:hutano/screens/login.dart';
import 'package:hutano/theme.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Flutter Home",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      // home: Login(),
      initialRoute: "/",
      routes: {
        '/': (context) => Login(),
        '/second': (context) => TextFieldDemo(),
      },
    ),
  );
}