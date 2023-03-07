part of sizer;

extension SizerExt on num {
  double get h => this * SizerUtil.height / 100;

  double get w => this * SizerUtil.width / 100;

  double get px => this * (SizerUtil.width / 375);

  double get sp => this * (SizerUtil.width / 3) / 100;
}


