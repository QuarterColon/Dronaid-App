import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroScreen1 extends StatefulWidget {
  const IntroScreen1({Key? key}) : super(key: key);

  @override
  _IntroScreen1State createState() => _IntroScreen1State();
}

class _IntroScreen1State extends State<IntroScreen1> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.105,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: size.height * 0.02),
          child: SizedBox(
            width: size.width * 0.8,
            child: Image.asset('assets/images/banner.png'),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/images/orange_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        height: size.height * 0.7,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height*0.02,
            ),
            Lottie.network(
                'https://assets3.lottiefiles.com/private_files/lf30_k985zjll.json'),
            const Text(
              "Lorem ipsum dolor sit amet. Ut exercitationem autem aut dolorum ",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}