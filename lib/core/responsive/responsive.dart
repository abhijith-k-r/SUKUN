import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  late double w;

  Responsive(this.context) {
    w = MediaQuery.of(context).size.width;
  }

  double get hSmall => w * 0.02;
  double get hMedium => w * 0.03;
  double get hLarge => w * 0.04;

  double get fieldWidth => w * 0.7;
  double get fieldHeight => w * 0.09;
  double get googleHeight => w * 0.10;

  double get titleSize => w * 0.045;
  double get subtitleSize => w * 0.035;
  double get buttonTextSize => 15; // keep same as now
}
