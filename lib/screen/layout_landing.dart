import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LayoutLanding extends StatelessWidget {
  final Widget child;
  const LayoutLanding({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight / 3.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/svg/ic_logo.svg'),
                  const Text('Real comfortability',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSans',
                          color: Colors.black38)),
                ],
              ),
            ),
            child,
          ],
        ),
      ),
    ));
  }
}
