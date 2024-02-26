import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> accountNames = [];
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    getAccounts();
  }

  getAccounts() async {
    setState(() {
      isLoading = true;
    });

    QuerySnapshot accountsSnap = await _firestore.collection('users').get();
    final accounts = accountsSnap.docs.map((doc) => doc.data()).toList().map((e) => {
      //accountNames.add((ModalRoute.of(context)!.settings.arguments! as Map)["username"].toString())
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    List<String> buttons = [
      "OOTD",
      "Aesthetic",
      "Style",
      "Outdoor",
      "DIY",
      "Homemade",
      "Date night",
      "Men",
      "Women",
      "Winter",
    ];

    List<String> accountNames = [
      "Sam",
      "Ben",
      "Ujjen",
      "Ben",
      "Bowman",
      "Terry"
    ];

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search Accounts",
                    contentPadding: EdgeInsets.all(0),
                    border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Color.fromRGBO(220, 220, 220, 1),
                  filled: true,
                  ),
                  controller: _searchController,
                ),
                
                const SizedBox(height: 10),

                isLoading ? const Center(
                  child: CircularProgressIndicator()
                ) 
                : SizedBox(
                  height: screenHeight-100,
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: accountNames.length,
                    itemBuilder: (context, index) { 
                     return ListTile(
                      title: Text(accountNames[index])
                    );},
                    separatorBuilder: (BuildContext context, int index){
                      return Divider();
                    }
                  ),
                )

              ],
            ),)
        ),
      )
    );

    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    //       SliverAppBar(
    //           title: TextFormField(
    //             decoration: InputDecoration(
    //               prefixIcon: Icon(Icons.search),
    //               hintText: "Search",
    //               contentPadding: EdgeInsets.all(0),
    //               border: OutlineInputBorder(
    //                 borderSide: BorderSide.none,
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               fillColor: Color.fromRGBO(220, 220, 220, 1),
    //               filled: true,
    //             ),
    //           ),
    //           actions: [
    //             IconButton(
    //               onPressed: () {},
    //               icon: Icon(Icons.person_add),
    //             )
    //           ]),
    //       SliverAppBar(
    //         title: SingleChildScrollView(
    //           scrollDirection: Axis.horizontal,
    //           child: Row(
    //             children: List.generate(
    //               10,
    //               (index) => Container(
    //                 padding: EdgeInsets.symmetric(horizontal: 5),
    //                 child: OutlinedButton(
    //                   onPressed: () {},
    //                   child: Text(
    //                     buttons[index],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

  }
}
