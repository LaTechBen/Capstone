import 'package:accentuate/components/my_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'home_page.dart';
import 'firebase_api_calls/firebase_write.dart';
import 'dart:io';
import 'dart:developer';
import './components/my_button.dart';

// Settings Screen UI, displays the SettingsList
class CreateOutfitPage extends StatefulWidget {
  const CreateOutfitPage({Key? key}) : super(key: key);

  @override
  State<CreateOutfitPage> createState() => _CreateOutfitPageState();
}

class _CreateOutfitPageState extends State<CreateOutfitPage> {
  final Write _write = Write();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var userdata = {};
  ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  

  @override
  void initState() {
    super.initState();
    getData();
  }

  void selectedImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if(selectedImages.isNotEmpty){
      imageFileList.addAll(selectedImages);
    }
    setState(() {
      
    });
  }

  getData() async {
    var userSnap =
        await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
    userdata = userSnap.data()!;
  }

  File selectedImage = File('');
  final HomePage _homePage = HomePage();

  setGalleryImage() async {
    try {
      selectedImage = await _homePage.getImageFromGallery();
      // setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  storeImage() async {
    await _write.uploadImage(
        '', selectedImage, _auth.currentUser!.uid, userdata['username'],
        isProfile: false);
  }

  List<File> convertXFileToFile(List<XFile> files) {
    List<File> output = [];
    for(XFile file in files){
      output.add(File(file.path));
    }
    return output;
  }

  storeImages(bool isPost) async {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Outfit saved.")));
    await _write.uploadImages(convertXFileToFile(imageFileList), isPost ,_auth.currentUser!.uid, userdata['username'], 'Description');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: imageFileList.length, 
                itemBuilder: (BuildContext context, int index) { 
                  return Image.file(File(imageFileList[index].path), fit: BoxFit.cover,);
                  },
              ),
            )),
            const SizedBox(height: 10.0,),
            (
            MyButton(text: "Save Outfit", onTap: () => {
              if(imageFileList.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select pictures to save.")))
              }
              else
              showDialog(context: context, builder: (context) => AlertDialog(
                actions: [
                  TextButton(onPressed: () {storeImages(false); Navigator.of(context).pop();}, 
                    child: const Text("No")), 
                  TextButton(onPressed: () {storeImages(true); Navigator.of(context).pop();}, 
                    child: const Text("Yes"))
                ],
                title: const Text("Make Outfit Public?"),
                contentPadding: const EdgeInsets.all(15.0),
                content: const Text("Would you like to save your outfit as a post to be made public?"),
              ))
            })
            ),
            const SizedBox(height: 10.0,),
            MyButton(text: "Choose Pictures", onTap: selectedImages),
            const SizedBox(height: 10.0,)
          ],
        ),
      ),
    );
  }
}