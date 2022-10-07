import 'package:flutter/material.dart';
import 'package:url_shortner/presentation/shortener_url_screen.dart';

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
            "Shorten Url Challenge",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        body: const ShortenerUrlScreen());
  }
}
