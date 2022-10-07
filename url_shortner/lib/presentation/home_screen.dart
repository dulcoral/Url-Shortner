import 'package:flutter/material.dart';
import 'package:url_shortner/constants/app_strings.dart';
import 'package:url_shortner/presentation/shortener_url_screen.dart';
import 'package:url_shortner/styles/text_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 3,
          title: const Text(
            AppStrings.appString,
            style: AppTextStyle.appBarTextStyle,
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        body: const ShortenerUrlScreen());
  }
}
