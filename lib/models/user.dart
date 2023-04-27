import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  const User({
    required this.username,
    required this.uid,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.admin,
    required this.photoUrl,
  });

  factory User.fromSnap(DocumentSnapshot<Object?> snap) {
    final Map<String, dynamic>? snapshot = snap.data() as Map<String, dynamic>?;

    return User(
      username: snapshot?['username'],
      uid: snapshot?['uid'],
      email: snapshot?['email'],
      bio: snapshot?['bio'],
      followers: snapshot?['followers'],
      following: snapshot?['following'],
      admin: snapshot?['admin'],
      photoUrl: snapshot?['photoUrl'],
    );
  }

  final String username;
  final String uid;
  final String email;
  final String bio;
  final List<dynamic> followers;
  final List<dynamic> following;
  final bool admin;
  final String photoUrl;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'followers': followers,
        'following': following,
        'admin': admin,
        'photoUrl': photoUrl,
      };
}
