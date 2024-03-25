import 'dart:io';

import 'package:accentuate/components/api_keys.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import "package:flutter_gemini/flutter_gemini.dart";
import "home_page.dart";

class ReverseSearch extends StatefulWidget {
  const ReverseSearch({super.key});

  @override
  State<ReverseSearch> createState() => _ReverseSearchState();
}

class _ReverseSearchState extends State<ReverseSearch> {
  bool isDummyData = false;
  final Uri _url = Uri.parse(
      "https://www.googleapis.com/customsearch/v1?key=$search_api&cx=$contextKey&q=&start=$start");
  File selectedImage = File('');
  final HomePage _homePage = HomePage();

  setGalleryImage() async {
    try {
      selectedImage = await _homePage.getImageFromGallery();

      geminiResult(image: selectedImage);

      // setState(() {});
    } catch (e) {
      // log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: TextButton(
        style: TextStyle(fontSize: 20),
        onPressed: () => {setGalleryImage()},
        child: Text('Click'),
      ),
    ));
  }

  void geminiResult(File image) {
    final gemini = Gemini.instance;
    gemini.textAndImage(
      text: "Find similar images.",
      images: [image.readAsBytesSync()],
    );
  }

  // Future<Map<String, dynamic>> fetchData({required String queryTerm, String start = "0"}) async {
  //   try{
  //     if (!isDummyData) {
  //       String q = queryTerm.contains(' ') ? queryTerm.split(' ').join('%20') : queryTerm;

  //       final response  = await http.get(Uri.parse("https://www.googleapis.com/customsearch/v1?key=$search_api&cx=$contextKey&q=$q&searchType=image&start=$start"));
  //     }
  //   } catch (e) {
  //     print(e.toString(),);
  //   }
  // }
}
