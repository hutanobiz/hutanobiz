import 'package:flutter/material.dart';
import 'package:hutano/screens/home.dart';
import 'package:hutano/screens/login.dart';
import 'package:hutano/theme.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Flutter Home",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: "/",
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    ),
  );
}
