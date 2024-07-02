import 'package:flutter/material.dart';

class LoadingDialog {
  static late BuildContext _dialogContext;

  static Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _dialogContext = context;
        return  Dialog(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.transparent,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> hideLoadingDialog() async {
    Navigator.pop(_dialogContext);
  }
}