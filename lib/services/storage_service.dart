import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:samsarah/services/database_service.dart';

class StorageService {
  final profileRef = FirebaseStorage.instance.ref().child("Profiles");
  final auth = FirebaseAuth.instance;
  final db = Database();
  Future<void> updateProfile(String path) async {
    final file = File(path);
    final ref = profileRef.child(auth.currentUser!.uid);
    await ref.putFile(file).whenComplete(() => null);
    final url = await ref.getDownloadURL();
    await auth.currentUser!.updatePhotoURL(url);
    await db.accountCollection
        .doc(auth.currentUser!.uid)
        .update({"imagePath": url});
  }
}
