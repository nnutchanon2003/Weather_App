import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(String username) async {
    await _db.collection('users').doc(username).set({
      'username': username,
    });
  }

  Future<bool> checkUserExists(String username) async {
    DocumentSnapshot doc = await _db.collection('users').doc(username).get();
    return doc.exists;
  }

  Future<void> updateSettings(String username, String units, String language, bool notificationsEnabled) async {
    await _db.collection('settings').doc(username).set({
      'username': username,
      'units': units,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
    });
  }

  Future<Map<String, dynamic>?> getSettings(String username) async {
    DocumentSnapshot doc = await _db.collection('settings').doc(username).get();
    return doc.exists ? doc.data() as Map<String, dynamic>? : null;
  }
}
