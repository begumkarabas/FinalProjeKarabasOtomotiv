import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void displayMessageToUser(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(message)));
  }

  void registeruser() async {
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);

      displayMessageToUser("Şifreler uyuşmuyor!", context);
    } else {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        Navigator.pop(context);

        final User? user = userCredential.user;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': user.email,
            'uid': user.uid,
            'createdAt': Timestamp.now(),
          });
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[200],
        foregroundColor: Colors.brown,
        title: const Text("Kayıt Ol"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "E-posta",
                labelStyle: TextStyle(color: Colors.brown),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown),
                ),
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Şifre",
                labelStyle: TextStyle(color: Colors.brown),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown),
                ),
              ),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: "Şifreyi Doğrula",
                labelStyle: TextStyle(color: Colors.brown),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                registeruser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
              child: const Text("Kayıt Ol"),
            ),
          ],
        ),
      ),
    );
  }
}
