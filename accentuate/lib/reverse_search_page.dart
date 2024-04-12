import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:accentuate/components/api_keys.dart';
import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:html/dom.dart' as dom;
// import 'package:http/http.dart' as http;
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:flutter_gemini/src/models/candidates/candidates.dart';
import 'home_page.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'components/api_keys.dart';

class ReverseSearch extends StatefulWidget {
  // final Widget child;
  const ReverseSearch({super.key});

  @override
  State<ReverseSearch> createState() => _ReverseSearchState();
}

class _ReverseSearchState extends State<ReverseSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
              ),
              onPressed: () => showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => GeminiResponse(
                  image: File('images/p2.jpg'),
                ),
              ),
              child: const Text(
                'Button',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GeminiResponse extends StatefulWidget {
  final File image;
  GeminiResponse({super.key, required this.image});
  List response = [];

  @override
  State<GeminiResponse> createState() => _GeminiResponseState();
}

class _GeminiResponseState extends State<GeminiResponse> {
  final gemini = GoogleGemini(apiKey: gemini_api);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GeminiResult(image: widget.image);
  }

  void GeminiResult({required File image}) async {
    await gemini
        .generateFromTextAndImages(
          query:
              "Find similar products and give me an image of the product with a description.",

          /// text
          image: image,
        )
        .then((value) => {
              setState(
                (
                  (_) {
                    widget.response.add({'text': value.text});
                  },
                ) as VoidCallback,
              )
            });
  }

  Widget makeDismissible(
          {required BuildContext context, required Widget child}) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return makeDismissible(
      context: context,
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(22),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: widget.response.length,
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              return ListTile(
                isThreeLine: true,
                subtitle: Text(widget.response[index]['text']),
              );
            },
          ),
        ),
      ),
    );
  }
}
