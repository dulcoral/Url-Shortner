import 'package:flutter/material.dart';
import 'package:url_shortner/constants/app_sizes.dart';

class AppTextStyle {
  static const titleStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.size_16);

  static const subtitleStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: AppSizes.size_12);

  static const appBarTextStyle = TextStyle(
      color: Colors.black,
      fontSize: AppSizes.size_24,
      fontWeight: FontWeight.bold);
}
