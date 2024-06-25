import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class Introduce extends StatelessWidget {
  const Introduce({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: screenHeight / 3,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(FlutterI18n.translate(context, "landing.text_1"),
                      style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  Text(FlutterI18n.translate(context, "landing.text_2"),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
            height: screenHeight / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(2),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 18, right: 18, top: 5, bottom: 5),
                    child: Text(
                        FlutterI18n.translate(context, "landing.sign_in"),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(2),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 16.5, right: 16.5),
                    child:
                        Text(FlutterI18n.translate(context, "landing.sign_up"),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF006FEE),
                            )),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
