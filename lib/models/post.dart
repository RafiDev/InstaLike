import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  factory Post.fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    final Map<String, dynamic>? snapshot = snap.data()?.cast<String, dynamic>();

    return Post(
      description: snapshot?['description'],
      uid: snapshot?['uid'],
      username: snapshot?['username'],
      postId: snapshot?['postId'],
      datePublished: snapshot?['datePublished'],
      postUrl: snapshot?['postUrl'],
      profImage: snapshot?['profImage'],
      likes: snapshot?['likes'],
    );
  }

  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final dynamic likes;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'description': description,
        'uid': uid,
        'username': username,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'likes': likes,
      };
}
