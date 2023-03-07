import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_sdk_flutter/src/constants.dart';
import 'package:sample_sdk_flutter/src/constants.dart';

TextStyle getCustomTextStyle({
  fontSize = 17,
  fontWeight = FontWeight.normal,
  color = kPrimaryTextColor,
}) {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: fontSize.toDouble(), color: color, fontWeight: fontWeight),
  );
}
