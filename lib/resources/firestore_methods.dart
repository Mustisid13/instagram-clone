
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/posts.dart';
import 'storage_methods.dart';

class FirestoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String res = "some error occurred";
  Future<String> uploadPosts({
    required String uid,
    required String desc,
    required Uint8List file,
  required String username,
    required String profImage
}) async {
    try{
      String postId = const Uuid().v1();
      String postUrl = await StorageMethods().uploadImageToStorage("posts",file,true);
      Post post = Post(
        description: desc,
        uid: uid,
        postUrl: postUrl,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        profImage: profImage,
        likes: [],
      );
      _firebaseFirestore.collection('posts').doc(postId).set(post.toJson());
      res="success";
    }catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<void> likePosts(String postId,String uid,List likes) async{
    try{
      if(likes.contains(uid)){
        await _firebaseFirestore.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }

    }catch(err){
      print(err.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name, String profPic) async {
    try{
      if(text.isNotEmpty){
        String commentId = Uuid().v1();
        await _firebaseFirestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic':profPic,
          'name':name,
          'text':text,
          'commentId':commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch(err){
      print(err.toString());
    }
  }

  // deleting the post

  Future<void> deletePost(String postId) async {
    try{
      await _firebaseFirestore.collection('posts').doc(postId).delete();
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> followUser(String uid,String followId) async{
    try{
      DocumentSnapshot snap = await _firebaseFirestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)){
        await _firebaseFirestore.collection('users').doc(followId).update(
          {'followers': FieldValue.arrayRemove([uid]),}
        );
        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else{
        await _firebaseFirestore.collection('users').doc(followId).update(
            {'followers': FieldValue.arrayUnion([uid]),}
        );
        await _firebaseFirestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    }catch(err){
      print(err.toString());
    }
  }



}