import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_x/auth/login_or_register.dart';
import 'package:insta_x/firebase_options.dart';
import 'package:insta_x/pages/home_page.dart';
import 'package:insta_x/pages/profile_page.dart';
import 'package:insta_x/pages/users_page.dart';
import 'package:insta_x/theme/dark_mode.dart';
import 'package:insta_x/theme/light_mode.dart';

import 'auth/auth.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: lightmode,
      darkTheme: darkMode,
      routes:{
        '/login_register_page':(context) => const Login_or_register(),
        '/home_page':(context) =>  HomePage() ,
        '/profile_page':(context) =>  ProfilePage(),
        '/users_page':(context) =>const UsersPage(),
      },
    );
  }
}
