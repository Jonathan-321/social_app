import 'package:flutter/material.dart';
import 'package:insta_x/pages/login_page.dart';
import 'package:insta_x/pages/register_page.dart';

class Login_or_register extends StatefulWidget {
  const Login_or_register({super.key});

  @override
  State<Login_or_register> createState() => _Login_or_registerState();
}

class _Login_or_registerState extends State<Login_or_register> {
  // initially , show a login page

  bool showLoginPage = true;

  // toggle between login and register page

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
