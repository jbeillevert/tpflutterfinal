import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_page.dart';
import 'database_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  Future<String> uploadImage(File image) async {
    String fileName =
        'notes/${FirebaseAuth.instance.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch.toString()}';
    UploadTask uploadTask =
        FirebaseStorage.instance.ref().child(fileName).putFile(image);

    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  void _showAddNoteDialog() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController textController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une note'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'Titre'),
                ),
                TextField(
                  controller: textController,
                  decoration: InputDecoration(hintText: 'Texte'),
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Choisir une image'),
                ),
                if (_pickedImage != null) Image.file(File(_pickedImage!.path)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ajouter'),
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    textController.text.isNotEmpty) {
                  String imageUrl = '';
                  if (_pickedImage != null) {
                    imageUrl = await uploadImage(File(_pickedImage!.path));
                  }
                  addNote(titleController.text, textController.text, imageUrl);
                  setState(() {
                    _pickedImage = null; // Réinitialiser l'image après l'ajout
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditNoteDialog(DocumentSnapshot document) {
    TextEditingController titleController =
        TextEditingController(text: document['title']);
    TextEditingController textController =
        TextEditingController(text: document['text']);
    String currentImageUrl =
        document['imageUrl']; // Récupérer l'URL actuelle de l'image

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Contenu de l'AlertDialog
          actions: <Widget>[
            // Boutons d'action
            TextButton(
              child: Text('Sauvegarder'),
              onPressed: () async {
                String imageUrl = currentImageUrl;
                if (_pickedImage != null) {
                  // Télécharger l'image et obtenir l'URL
                  imageUrl = await uploadImage(File(_pickedImage!.path));
                }
                if (titleController.text.isNotEmpty &&
                    textController.text.isNotEmpty) {
                  updateNote(document.id, titleController.text,
                      textController.text, imageUrl);
                  setState(() {
                    _pickedImage =
                        null; // Réinitialiser l'image après la modification
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AuthPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getUserNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Une erreur est survenue: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title'] ?? 'Sans titre'),
                subtitle: Text(data['text'] ?? 'Pas de contenu'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showEditNoteDialog(document),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteNote(document.id),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _showAddNoteDialog,
      ),
    );
  }
}
