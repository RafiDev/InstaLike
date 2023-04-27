import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = 'some error occurred';
    try {
      final String photoUrl = await StorageMethods().uploadImageToStorage(
        childName: 'posts',
        file: file,
        isPost: true,
      );
      final String postId = const Uuid().v1();
      final Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: <dynamic>[],
      );
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List<dynamic> likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .update(<Object, Object?>{
          'likes': FieldValue.arrayRemove(<dynamic>[uid]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .update(<Object, Object?>{
          'likes': FieldValue.arrayUnion(<dynamic>[uid]),
        });
      }
    } catch (err) {
      stdout.writeln(err.toString());
    }
  }

  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    try {
      if (text.isNotEmpty) {
        final String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(<String, dynamic>{
          'profilePic': profilePic,
          'name': name,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {}
    } catch (err) {
      stdout.writeln(err.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      stdout.writeln(err.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snap =
          await _firestore.collection('users').doc(uid).get();
      final List<dynamic> following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore
            .collection('users')
            .doc(followId)
            .update(<Object, Object?>{
          'followers': FieldValue.arrayRemove(<dynamic>[uid])
        });

        await _firestore
            .collection('users')
            .doc(followId)
            .update(<Object, Object?>{
          'followers': FieldValue.arrayRemove(<dynamic>[followId])
        });
      } else {
        await _firestore
            .collection('users')
            .doc(followId)
            .update(<Object, Object?>{
          'followers': FieldValue.arrayUnion(<dynamic>[uid])
        });

        await _firestore
            .collection('users')
            .doc(followId)
            .update(<Object, Object?>{
          'followers': FieldValue.arrayUnion(<dynamic>[followId])
        });
      }
    } catch (err) {
      stdout.writeln(err.toString());
    }
  }
}
