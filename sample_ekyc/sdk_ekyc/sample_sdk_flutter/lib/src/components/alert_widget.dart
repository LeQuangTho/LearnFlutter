import 'package:flutter/material.dart';
import '../utils/recog_status.dart';
import '../utils/recog_result_status.dart';

Widget getAlertWidget(RecogStatus status, var size) {
  return Container(
    height: 70,
    margin: EdgeInsets.all(size.width * 0.05),
    decoration: BoxDecoration(
        color: Colors.black, borderRadius: BorderRadius.circular(6.0)),
    child: Row(
      children: <Widget>[
        status.warningIcon,
        SizedBox(
          width: 20,
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                status.title,
              ),
              Text(
                status.message,
              )
            ],
          ),
        )
      ],
    ),
  );
}
