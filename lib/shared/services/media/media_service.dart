// lib/shared/services/media_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class MediaService {
  final _storage = FirebaseStorage.instance;

  /// Uploads [file] to [path] and returns the public download-URL.
  Future<String> upload(File file, String path) async {
    final ref = _storage.ref().child(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
