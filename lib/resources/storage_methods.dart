import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage({
    required String childName,
    required Uint8List file,
    bool isPost = false,
  }) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      final String id = const Uuid().v1();
      ref = ref.child(id);
    }

    final UploadTask uploadTask = ref.putData(file);
    final TaskSnapshot snap = await uploadTask;
    final String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }
}
