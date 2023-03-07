import 'package:flutter/material.dart';
import '../utils/recog_status.dart';
import '../utils/recog_result_status.dart';

Widget getAlertWidget(RecogResultStatus status, var size,
    {String message = "Thẻ không hợp lệ"}) {
  return Container(
    height: 80,
    width: size.width * 0.9,
    decoration:
        boxDecoration(bgColor: Colors.white, radius: 10, showShadow: true),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          width: 20,
        ),
        Image.asset('assets/images/Group_20.png',
            package: 'sample_sdk_flutter', width: 70),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Không hợp lệ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                Container(
                  child: Text(
                    message,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.transparent,
    Color? bgColor,
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor ?? Colors.black,
    boxShadow: [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}
