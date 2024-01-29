// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';



// fetchRecords(String id, String collectionName) async {
//   var records = await FirebaseFirestore.instance.collection(collectionName).doc(id).get();
//   switch(collectionName)
//   {
//     case 'users':
//       return mapUserRecords(records);
    
//   }
// }



// mapUserRecords(QuerySnapshot<Map<String, dynamic>> records) {
//   records.docs.map(
//     (item) => Item(
//         id: item.id,
//         email: item['email'],
//         password: item['password'],
//         username: item['username']),
//   );
// }
