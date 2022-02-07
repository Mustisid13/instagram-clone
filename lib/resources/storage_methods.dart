import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageMethods {
  FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  // adding image to firebase storage

  Future<String>uploadImageToStorage(String childName, Uint8List file, bool isPost) async{
    Reference ref = _storage.ref().child(childName).child(_firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(file);

   TaskSnapshot snap = await uploadTask;
   String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}