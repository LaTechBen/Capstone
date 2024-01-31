import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class ReadData extends StatelessWidget {
//   const ReadData({super.key});

//   Widget readData(BuildContext context, String id, String tableName) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection(tableName).snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         return ListView(
//           children: snapshot.data!.docs.map((document) {
//             return Container(
//               child: Center(child: Text(document['username'])),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }
