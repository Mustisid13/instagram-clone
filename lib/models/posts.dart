import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String postUrl;
  final String username;
  final String postId;
  final String profImage;
  final likes;
  final DateTime datePublished;

  const Post( {
    required this.description,
    required this.uid,
    required this.postUrl,
    required this.username,
    required this.postId,
    required this.profImage,
    required this.likes,
    required this.datePublished
  });

  Map<String,dynamic> toJson() => {
    'description':description,
    "uid":uid,
    "postId":postId,
    "postUrl":postUrl,
    "username":username,
    "profImage":profImage,
    "likes":likes,
    "datePublished":datePublished
  };

  static Post fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String,dynamic>;

    return Post(
      username: snap['username'],
      uid: snap['uid'],
      postId: snap['postId'],
      postUrl: snap['postoUrl'],
      description: snap['description'],
      likes: snap['likes'],
      profImage: snap['profImage'],
      datePublished: snap['datePublished']
    );
  }
}
