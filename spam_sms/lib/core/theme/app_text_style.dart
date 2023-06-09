import 'package:flutter/material.dart';
import 'package:spam_sms/core/theme/gen/colors.gen.dart';

extension AppStyle on TextStyle {
  // Text Style
  /// * [fontFamily] = Roboto-Bold
  static final TextStyle bold = const TextStyle(fontFamily: 'Roboto-Bold');

  /// * [fontFamily] = Roboto-Regular
  /// * [fontWeight] = FontWeight.w600
  static final TextStyle semiBold = const TextStyle(
    fontFamily: 'Roboto-Regular',
    fontWeight: FontWeight.w600,
  );

  /// [fontFamily] = Roboto-Regular
  static final TextStyle regular =
      const TextStyle(fontFamily: 'Roboto-Regular');

  /// [fontFamily] = Roboto-Medium
  static final TextStyle medium = const TextStyle(fontFamily: 'Roboto-Medium');

  static final TextStyle upper = const TextStyle(
    fontFamily: 'Roboto-Regular',
    fontWeight: FontWeight.w400,
  );

  /// [fontStyle] = FontStyle.italic
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// [decoration] = TextDecoration.underline
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);

  /// [decoration] = TextDecoration.underline
  TextStyle get oneLine => copyWith(height: 1.2);

  // Text Style -> Display
  /// [fontSize] = 40 , [height] = 56 / 40
  TextStyle get display => copyWith(fontSize: 40, height: 56 / 40);

  /// [fontFamily] = Roboto-Regular , [fontSize] = 40 , [height] = 56 / 40
  static final TextStyle displayRegular = regular.display;

  /// [fontFamily] = Roboto-Bold , [fontSize] = 40 , [height] = 56 / 40
  static final TextStyle displayBold = bold.display;

  // Text Style -> Header
  /// [fontSize] = 30 , [height] = 44 / 30
  TextStyle get header => copyWith(fontSize: 30, height: 44 / 30);

  /// [fontFamily] = Roboto-Medium , [fontSize] = 30 , [height] = 44 / 30
  static final TextStyle headerMedium = medium.header;

  /// [fontFamily] = Roboto-Medium , [fontSize] = 30 , [height] = 44 / 30
  static final TextStyle headerRegular = regular.header;

  /// [fontFamily] = Roboto-Bold , [fontSize] = 30 , [height] = 44 / 30
  static final TextStyle headerBold = bold.header;

  // Text Style -> Title
  /// [fontSize] = 24 , [height] = 36 / 24
  TextStyle get title => copyWith(fontSize: 24, height: 36 / 24);

  /// [fontFamily] = Roboto-Regular , [fontSize] = 24 , [height] = 36 / 24
  static final TextStyle titleRegular = regular.title;

  /// [fontFamily] = Roboto-Bold , [fontSize] = 24 , [height] = 36 / 24
  static final TextStyle titleBold = bold.title;

  // Text Style -> Body
  /// [fontSize] = 16 , [height] = 20 / 16
  TextStyle get body => copyWith(fontSize: 16, height: 20 / 16);

  /// [fontFamily] = Roboto-Regular , [fontSize] = 16 , [height] = 20 / 16
  static final TextStyle bodyRegular = regular.body;

  /// [fontFamily] = Roboto-Medium , [fontSize] = 16 , [height] = 20 / 16
  static final TextStyle bodyMedium = medium.body;

  /// [fontFamily] = Roboto-Medium , [fontSize] = 16 , [height] = 20 / 16
  static final TextStyle bodySemiBold = semiBold.body;

  /// [fontFamily] = Roboto-Bold , [fontSize] = 16 , [height] = 20 / 16
  static final TextStyle bodyBold = bold.body;

  // Text Style -> Header
  /// [fontSize] = 24 , [height] = 32 / 24
  static final TextStyle h2 = const TextStyle(
    height: 32 / 24,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  /// [fontSize] = 20 , [height] = 24 / 20
  static final TextStyle h3 = const TextStyle(
    height: 24 / 20,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  // Text Style -> Paragraph
  /// [fontSize] = 16 , [height] = 24 / 16
  TextStyle get paragraph => copyWith(fontSize: 16, height: 24 / 16);

  /// [fontFamily] = Roboto-Regular , [fontSize] = 16 , [height] = 24 / 16
  static final TextStyle paragraphRegular = regular.paragraph;

  /// [fontFamily] = Roboto-Regular , [fontSize] = 14 , [height] = 24 / 14
  static final TextStyle paragraphRegularSmall = regular.copyWith(
    fontSize: 14,
    height: 24 / 14,
  );

  /// [fontFamily] = Roboto-Regular , [fontSize] = 14 , [height] = 24 / 14
  static final TextStyle paragraphSemiBoldSmall = semiBold.copyWith(
    fontSize: 14,
    height: 24 / 14,
  );

  /// [fontFamily] = Roboto-Medium , [fontSize] = 16 , [height] = 24 / 16
  static final TextStyle paragraphMedium = medium.paragraph;

  /// [fontFamily] = Roboto-Bold , [fontSize] = 16 , [height] = 24 / 16
  static final TextStyle paragraphBold = bold.paragraph;

  /// [fontFamily] = Roboto-Regular , [fontSize] = 16 , [height] = 24 / 16
  static final TextStyle paragraphSemiBold = semiBold.paragraph;

  // Text Style -> Caption
  /// [fontSize] = 12 , [height] = 18 / 12
  TextStyle get caption => copyWith(fontSize: 12, height: 18 / 12);

  /// [fontFamily] = Roboto-Regular , [fontSize] = 12 , [height] = 18 / 12
  static final TextStyle captionRegular = regular.caption;

  /// [fontFamily] = Roboto-Medium , [fontSize] = 12 , [height] = 18 / 12
  static final TextStyle captionMedium = medium.caption;

  ///[fontFamily] = Roboto-Bold , [fontSize] = 12 , [height] = 18 / 12
  static final TextStyle captionBold = bold.caption;

  // Text Style -> xSmall
  /// [fontSize] = 12 , [height] = 16 / 12
  TextStyle get xSmall => copyWith(fontSize: 12, height: 16 / 12);

  /// [fontFamily] = Roboto-Regular , [fontSize] = 12 , [height] = 16 / 12
  static final TextStyle xSmallRegular = regular.xSmall;

  /// [fontFamily] = Roboto-Medium , [fontSize] = 12 , [height] = 16 / 12
  static final TextStyle xSmallMedium = medium.xSmall;

  ///[fontFamily] = Roboto-Bold , [fontSize] = 12 , [height] = 16 / 12
  static final TextStyle xSmallSemiBold = semiBold.xSmall;

  ///[fontFamily] = Roboto-Bold , [fontSize] = 12 , [height] = 16 / 12
  static final TextStyle xSmallBold = bold.xSmall;

  // Text Style -> Over line
  /// [fontSize] = 10 , [height] = 16 / 10
  TextStyle get overLine => copyWith(fontSize: 10, height: 16 / 10);

  /// [fontFamily] = Roboto-Medium , [fontSize] = 10 , [height] = 16 / 10
  static final TextStyle overLineMedium = medium.overLine;

  /// [fontFamily] = Roboto-Medium , [fontSize] = 10 , [height] = 16 / 10
  static final TextStyle overLineSemiBold = semiBold.overLine;

  /// [fontFamily] = Roboto-Bold , [fontSize] = 10 , [height] = 16 / 10
  static final TextStyle overLineBold = bold.overLine;

  // Text Style -> Small
  /// [fontSize] = 14 , [height] = 21 / 14
  TextStyle get small => copyWith(fontSize: 14, height: 20 / 14);

  /// [fontFamily] = Roboto-Regular , [fontSize] = 14 , [height] = 20 / 14
  static final TextStyle smallRegular = regular.small;

  /// [fontFamily] = Roboto-Medium , [fontSize] = 14 , [height] = 20 / 14
  static final TextStyle smallMedium = medium.small;

  /// [fontFamily] = Roboto-Medium , [fontSize] = 14 , [height] = 20 / 14
  static final TextStyle smallSemiBold = semiBold.small;

  ///[fontFamily] = Roboto-Bold , [fontSize] = 14 , [height] = 20 / 14
  static final TextStyle smallBold = bold.small;

  ///[fontFamily] = Roboto-Regular , [fontSize] = 14 , [height] = 20 / 14
  static final TextStyle smallUpper = upper.small;

  // Text Style -> Small
  /// [fontSize] = 10 , [height] = 12 / 10
  TextStyle get tiny => copyWith(fontSize: 10, height: 12 / 10);

  /// [fontFamily] = Roboto-Regular , [fontSize] = 10 , [height] = 12 / 10
  static final TextStyle tinyRegular = regular.tiny;

  /// [fontFamily] = Roboto-Regular , [fontSize] = 10 , [height] = 12 / 10
  static final TextStyle tinySemiBold = semiBold.tiny;
}

extension AppFontWeight on TextStyle {
  ///[fontWeight] = 100
  TextStyle get w100 => copyWith(fontWeight: FontWeight.w100);

  ///[fontWeight] = 200
  TextStyle get w200 => copyWith(fontWeight: FontWeight.w200);

  ///[fontWeight] = 300
  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);

  ///[fontWeight] = 400
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);

  ///[fontWeight] = 500
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);

  ///[fontWeight] = 600
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);

  ///[fontWeight] = 700
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);

  ///[fontWeight] = 800
  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);

  ///[fontWeight] = 900
  TextStyle get w900 => copyWith(fontWeight: FontWeight.w900);
}

extension AppFontColorTeal on TextStyle {
  ///[color] = teal500
  TextStyle get teal500 => copyWith(color: AppColor.teal500);

  ///[color] = teal600
  TextStyle get teal600 => copyWith(color: AppColor.teal600);
}

extension AppFontColorYellow on TextStyle {
  ///[color] = yellow000
  TextStyle get yellow000 => copyWith(color: AppColor.yellow000);

  ///[color] = yellow200
  TextStyle get yellow200 => copyWith(color: AppColor.yellow200);

  ///[color] = yellow400
  TextStyle get yellow400 => copyWith(color: AppColor.yellow400);

  ///[color] = yellow500
  TextStyle get yellow500 => copyWith(color: AppColor.yellow500);

  ///[color] = yellow600
  TextStyle get yellow600 => copyWith(color: AppColor.yellow600);
}

extension AppFontColorGreen on TextStyle {
  ///[color] = green000
  TextStyle get green000 => copyWith(color: AppColor.green000);

  ///[color] = green200
  TextStyle get green200 => copyWith(color: AppColor.green200);

  ///[color] = green300
  TextStyle get green300 => copyWith(color: AppColor.green300);

  ///[color] = green400
  TextStyle get green400 => copyWith(color: AppColor.green400);

  ///[color] = green500
  TextStyle get green500 => copyWith(color: AppColor.green500);

  ///[color] = green600
  TextStyle get green600 => copyWith(color: AppColor.green600);

  ///[color] = green700
  TextStyle get green700 => copyWith(color: AppColor.green700);
}

extension AppFontColorRed on TextStyle {
  ///[color] = red000
  TextStyle get red000 => copyWith(color: AppColor.red000);

  ///[color] = red100
  TextStyle get red100 => copyWith(color: AppColor.red100);

  ///[color] = red200
  TextStyle get red200 => copyWith(color: AppColor.red200);

  ///[color] = red300
  TextStyle get red300 => copyWith(color: AppColor.red300);

  ///[color] = red400
  TextStyle get red400 => copyWith(color: AppColor.red400);

  ///[color] = red500
  TextStyle get red500 => copyWith(color: AppColor.red500);

  ///[color] = red600
  TextStyle get red600 => copyWith(color: AppColor.red600);
}

extension AppFontColorWhite on TextStyle {
  ///[white] = white
  TextStyle get white => copyWith(color: AppColor.white);

  ///[color] = white8
  TextStyle get white8 => copyWith(color: AppColor.white8);

  ///[color] = white20
  TextStyle get white20 => copyWith(color: AppColor.white20);

  ///[color] = white40
  TextStyle get white40 => copyWith(color: AppColor.white40);

  ///[color] = white60
  TextStyle get white60 => copyWith(color: AppColor.white60);

  ///[color] = white80
  TextStyle get white80 => copyWith(color: AppColor.white80);

  ///[color] = white90
  TextStyle get white90 => copyWith(color: AppColor.white90);
}

extension AppFontColorNeutral on TextStyle {
  ///[color] = neutral000
  TextStyle get neutral000 => copyWith(color: AppColor.neutral000);

  ///[color] = neutral100
  TextStyle get neutral100 => copyWith(color: AppColor.neutral100);

  ///[color] = neutral200
  TextStyle get neutral200 => copyWith(color: AppColor.neutral200);

  ///[color] = neutral300
  TextStyle get neutral300 => copyWith(color: AppColor.neutral300);

  ///[color] = neutral400
  TextStyle get neutral400 => copyWith(color: AppColor.neutral400);

  ///[color] = neutral500
  TextStyle get neutral500 => copyWith(color: AppColor.neutral500);

  ///[color] = neutral600
  TextStyle get neutral600 => copyWith(color: AppColor.neutral600);

  ///[color] = neutral700
  TextStyle get neutral700 => copyWith(color: AppColor.neutral700);

  ///[color] = neutral800
  TextStyle get neutral800 => copyWith(color: AppColor.neutral800);

  ///[color] = neutral900
  TextStyle get neutral900 => copyWith(color: AppColor.neutral900);
}

extension AppFontColorPrimary on TextStyle {
  ///[color] = primary50
  TextStyle get primary50 => copyWith(color: AppColor.primary50);

  ///[color] = primary75
  TextStyle get primary75 => copyWith(color: AppColor.primary75);

  ///[color] = primary000
  TextStyle get primary000 => copyWith(color: AppColor.primary000);

  ///[color] = primary100
  TextStyle get primary100 => copyWith(color: AppColor.primary100);

  ///[color] = primary200
  TextStyle get primary200 => copyWith(color: AppColor.primary200);

  ///[color] = primary300
  TextStyle get primary300 => copyWith(color: AppColor.primary300);

  ///[color] = primary400
  TextStyle get primary400 => copyWith(color: AppColor.primary400);

  ///[color] = primary500
  TextStyle get primary500 => copyWith(color: AppColor.primary500);

  ///[color] = primary600
  TextStyle get primary600 => copyWith(color: AppColor.primary600);

  ///[color] = primary700
  TextStyle get primary700 => copyWith(color: AppColor.primary700);
}

extension AppFontColorDark on TextStyle {
  ///[color] = dark5
  TextStyle get dark5 => copyWith(color: AppColor.dark5);

  ///[color] = dark40
  TextStyle get dark40 => copyWith(color: AppColor.dark40);
}

extension AppFontColorError on TextStyle {
  ///[color] = error100
  TextStyle get error100 => copyWith(color: AppColor.error100);

  ///[color] = error200
  TextStyle get error200 => copyWith(color: AppColor.error200);
}

extension AppFontColorSuccess on TextStyle {
  ///[success100] = success100
  TextStyle get success100 => copyWith(color: AppColor.success100);

  ///[success400] = success400
  TextStyle get success400 => copyWith(color: AppColor.success400);
}

extension AppFontColorWarning on TextStyle {
  ///[warning300] = warning300
  TextStyle get warning300 => copyWith(color: AppColor.warning300);

  ///[warning300] = warning400
  TextStyle get warning400 => copyWith(color: AppColor.warning400);
}

extension AppFontColorSupport on TextStyle {
  ///[color] = supportWhis
  TextStyle get supportWhis => copyWith(color: AppColor.supportWhis);

  ///[color] = supportKrillin
  TextStyle get supportKrillin => copyWith(color: AppColor.supportKrillin);

  ///[color] = supportDodoria
  TextStyle get supportDodoria => copyWith(color: AppColor.supportDodoria);

  ///[color] = supportFrieza
  TextStyle get supportFrieza => copyWith(color: AppColor.supportFrieza);

  ///[color] = supportNappa
  TextStyle get supportNappa => copyWith(color: AppColor.supportNappa);

  ///[color] = supportChichi
  TextStyle get supportChichi => copyWith(color: AppColor.supportChichi);

  ///[color] = support100ß
  TextStyle get support100 => copyWith(color: AppColor.support100);

  ///[color] = support200
  TextStyle get support200 => copyWith(color: AppColor.support200);

  ///[color] = support500
  TextStyle get support500 => copyWith(color: AppColor.support500);
}

extension AppFontColorOrange on TextStyle {
  ///[color] = orange400
  TextStyle get orange400 => copyWith(color: AppColor.orange400);
}

extension AppFontColorNone on TextStyle {
  ///[color] = supportRashi
  TextStyle get krillin => copyWith(color: AppColor.krillin);

  ///[color] = card
  TextStyle get card => copyWith(color: AppColor.krillin);

  ///[color] = lightBeerus
  TextStyle get lightBeerus => copyWith(color: AppColor.lightBeerus);

  ///[color] = tag
  TextStyle get tag => copyWith(color: AppColor.tag);

  ///[color] = card
  TextStyle get black => copyWith(color: Colors.black);
}
