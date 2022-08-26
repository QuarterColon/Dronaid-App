import 'package:flutter/material.dart';
import 'Screens/Home/homeScreen.dart';
import 'Screens/Home/personalData.dart';
import 'Screens/Login/loginScreen.dart';
import 'Screens/SignUp/signUp.dart';
import 'constants.dart';

import 'introScreens/splashScreen.dart';
import 'onBoardingScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Color(0xFFE3E5FF),
        ),
      ),
      initialRoute: 'start',
      routes: {
        'onBoarding': (context) => OnBoardingScreen(),
        'start': (context) => SplashScreen(),
        'login': (context) => const LoginScreen(),
        'signUp': (context) => const SignUp(),
        'home': (context) => HomeScreen(),
        'Personal Data': (context) => PersonalData(),
      },
    );
  }
}