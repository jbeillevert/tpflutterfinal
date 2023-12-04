import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';



Future<void> addNote(String title, String text, String imageUrl) async {
  User? user = FirebaseAuth.instance.currentUser;
  

  // Ajouter la note avec l'URL de l'image
  if (user != null) {
    await FirebaseFirestore.instance.collection('notes').add({
      'userId': user.uid,
      'title': title,
      'text': text,
      'creationDate': FieldValue.serverTimestamp(),
      'imageUrl': imageUrl
    });
  }
}

Stream<QuerySnapshot> getUserNotes() {
  User? user = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance
      .collection('notes')
      .where('userId', isEqualTo: user?.uid)
      .orderBy('creationDate', descending: true)
      .snapshots();
}

Future<void> updateNote(String noteId, String title, String text, String imageUrl) async {
  await FirebaseFirestore.instance.collection('notes').doc(noteId).update({
    'title': title,
    'text': text,
    // Mettre à jour 'imageUrl' que si elle est fournie
    if (imageUrl.isNotEmpty) 'imageUrl': imageUrl,
  });
}

Future<void> deleteNote(String noteId) async {
  await FirebaseFirestore.instance.collection('notes').doc(noteId).delete();
}
