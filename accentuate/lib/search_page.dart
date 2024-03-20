import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:string_similarity/string_similarity.dart'; 

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<DocumentSnapshot>>? _searchResults;

  Future<List<DocumentSnapshot>> getSearchResults(String query) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String searchLower = query.toLowerCase();
  final snapshot = await firestore.collection('posts').get();

  // Calculate relevance scores for each document based on description similarity
  var scoredDocs = snapshot.docs.map((doc) {
    var data = doc.data() as Map<String, dynamic>;
    var description = data['description'].toLowerCase();
    double similarity = description.similarityTo(searchLower); // Calculate similarity
    return {'doc': doc, 'score': similarity}; // Return document with its score
  }).toList();

  // Sort documents based on relevance score (descending order)
  scoredDocs.sort((a, b) {
    final scoreA = a['score'] as double?;
    final scoreB = b['score'] as double?;
    if (scoreA != null && scoreB != null) {
      return scoreB.compareTo(scoreA);
    } else {
      return 0; 
    }
  });

  // Extract sorted documents without scores
  var sortedDocs = scoredDocs
      .map<DocumentSnapshot>((scoredDoc) => scoredDoc['doc'] as DocumentSnapshot)
      .toList();

  print('Search Results:');
  sortedDocs.forEach((doc) {
    print(doc.data()); 
  });

  // Limit results to 15 documents
  return sortedDocs.take(15).toList(); 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                setState(() {
                  _searchResults = getSearchResults(_searchController.text);
                });
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
              ),
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _searchResults = getSearchResults(value);
                  });
                }
              },
            ),
          ),
          Expanded(
            child: _searchResults == null
                ? Center(child: Text('Enter a search term to begin'))
                : FutureBuilder<List<DocumentSnapshot>>(
                    future: _searchResults,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No results found'));
                      }

                      var docs = snapshot.data!;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          var data = docs[index].data() as Map<String, dynamic>;
                          return Image.network(data['postUrl'], fit: BoxFit.cover);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
