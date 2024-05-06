import 'dart:developer';
import 'package:accentuate/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:string_similarity/string_similarity.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late Future<List<DocumentSnapshot>> _trendingPosts;
  Future<List<DocumentSnapshot>>? _searchPostResults;
  Future<List<DocumentSnapshot>>? _searchUserResults;
  String _currentView = 'posts';

  @override
  void initState() {
    super.initState();
    _trendingPosts = getTrendingPosts();
  }

  Future<List<DocumentSnapshot>> getTrendingPosts() async {
  final snapshot = await _firebase.collectionGroup('posts').orderBy('likesCount', descending: true).limit(25).get();
  return snapshot.docs;
}

Future<List<DocumentSnapshot>> searchPosts(String query) async {
  final snapshot = await _firebase.collectionGroup('posts').get();
  List<DocumentSnapshot> posts = snapshot.docs;

  if (query.isNotEmpty) {
    posts = posts.where((post) {
      var description = (post.data() as Map<String, dynamic>)['description'];
      double score = _calculateRelevanceScore(description ?? '', query); 
      return score > 0.5; 
    }).toList();

    posts.sort((a, b) {
      var descriptionA = (a.data() as Map<String, dynamic>)['description'];
      var descriptionB = (b.data() as Map<String, dynamic>)['description'];
      double scoreA = _calculateRelevanceScore(descriptionA ?? '', query);
      double scoreB = _calculateRelevanceScore(descriptionB ?? '', query);
      return scoreB.compareTo(scoreA);
    });
  }

  return posts.take(25).toList();
}

  Future<List<DocumentSnapshot>> getUsers(String query) async {
    final snapshot = await _firebase.collection('users').get();
    List<DocumentSnapshot> users = snapshot.docs;

    // Handle Null Case for Users and Weight
    if (query.isNotEmpty) {
      users = users.where((user) {
        var username = (user.data() as Map<String, dynamic>)['username'];
        double score = _calculateRelevanceScore(username ?? '', query); 
        return score > 0.5; 
      }).toList();
    }

    // Limit Results to 25 'users'
    return users.take(25).toList();
  }

  double _calculateRelevanceScore(String text, String query) {
    return text.similarityTo(query);
  }

  void _toggleView(String view) {
    setState(() {
      _currentView = view;
    });
  }

    goToUserPage(BuildContext context, DocumentSnapshot<Object?> uid){
    String userUid = uid.reference.id;
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserPage(uid: userUid)));
  }
  
   Widget _buildPostItem(DocumentSnapshot postSnapshot) {
    var post = postSnapshot.data() as Map<String, dynamic>;
    var postUrls = post['postUrl'] as List<dynamic>;
    String imageUrl = postUrls.isNotEmpty ? postUrls[0] : ''; 
    int likesCount = (post['likes'] as List).length; // Count the likes

    return Image.network(imageUrl, fit: BoxFit.cover);
  }

  Widget _buildUserItem(DocumentSnapshot userSnapshot) {
    var user = userSnapshot.data() as Map<String, dynamic>;
    var username = user['username'] ?? ''; 

    return ListTile(
      title: Text(username),
      onTap: () => goToUserPage(context, userSnapshot),                               
    );
  }
  
  // Format and UI Elements
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search),
              SizedBox(width: 4),
              Text("Search"),
            ],
          ),
        ),
        leading: null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _toggleView('posts'),
                  icon: Icon(Icons.whatshot),
                  label: Text('Trending Posts'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _toggleView('people'),
                  icon: Icon(Icons.person),
                  label: Text('People'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentView == 'posts'
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchPostResults = searchPosts(value);
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Search Posts",
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<DocumentSnapshot>>(
                          future: _searchPostResults ?? _trendingPosts,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(child: Text('No matching posts found'));
                            }

                            var posts = snapshot.data!;
                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                              ),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return _buildPostItem(posts[index]);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchUserResults = getUsers(value);
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Search Users",
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<DocumentSnapshot>>(
                          future: _searchUserResults,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(child: Text('No matching users found'));
                            }

                            var users = snapshot.data!;
                            return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                return _buildUserItem(users[index]);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    title: 'Search Page',
    home: SearchPage(),
  ));
}
