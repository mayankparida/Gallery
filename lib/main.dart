import 'package:app/screens/gallery_screen.dart';
import 'package:app/screens/pin_screen.dart';
import 'screens/big_screen.dart';
import 'package:flutter/material.dart';
import 'screens/pin_screen.dart';

void main() => runApp(GalleryApp());

class GalleryApp extends StatefulWidget {
  @override
  _GalleryAppState createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.grey.shade900,
          splashColor: Colors.redAccent,
          highlightColor: Colors.red.shade200,
          scaffoldBackgroundColor: Colors.black),
      initialRoute: PinScreen.id,
      routes: {
        PinScreen.id: (context) => PinScreen(),
        GalleryScreen.id: (context) => GalleryScreen(),
        BigScreen.id: (context) => BigScreen()
      },
    );
  }
}
