import 'package:flutter/material.dart';
import 'package:uiux_ekyc_flutter_sdk/components/primary_button.dart';

void showTimeOutDialog(BuildContext context,
    {String? imagePath,
    String? message = "Ảnh không hợp lệ",
    Function? callback}) {
  var size = MediaQuery.of(context).size;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            margin: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.18,
                20,
                MediaQuery.of(context).size.height * 0.18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Image.asset('assets/images/result_failed_icon.png',
                      package: 'sample_sdk_flutter'),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: size.width,
                  child: Text(
                    message!,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                PrimaryButton(
                  onPressed: callback == null
                      ? () {
                          // Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      : () {
                          callback();
                        },
                  text: "OK",
                  color: Color(0x2D88FF),
                  fontSize: 15,
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
