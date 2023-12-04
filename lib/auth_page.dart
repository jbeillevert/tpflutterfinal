import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notes_page.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

Future<void> _signIn() async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => NotesPage()),
    );
  } on FirebaseAuthException catch (e) {
    // Gérer les erreurs d'authentification
  }
}

Future<void> _signUp() async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    // Affichez un SnackBar après une inscription réussie
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Inscription réussie')),
    );
    // Naviguer vers la page principale après l'inscription
  } on FirebaseAuthException catch (e) {
    // Gérer les erreurs d'authentification
    print(e); // Afficher l'erreur dans la console
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur d'inscription: ${e.message}")),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion / Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Connexion'),
            ),
            ElevatedButton(
              onPressed: _signUp,
              child: const Text('Inscription'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
