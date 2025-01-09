import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
import 'company_owner_screen.dart';
import 'cars_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedRole;

  void displayMessageToUser(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(message)));
  }

  void login() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (selectedRole == "Şirket Sahibi") {
        final authorizedEmails = ["ugur@gmail.com", "erkan@gmail.com"];
        const authorPassword = "sifre";
        if (authorizedEmails.contains(_emailController.text.trim())) {
          if (authorPassword == _passwordController.text.trim()) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CompanyOwnerScreen()),
            );
          }
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Yetkili bir şirket sahibi hesabı bulunamadı.")),
          );
        }
      } else if (selectedRole == "Müşteri") {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CarsList()),
          );
        } on FirebaseAuthException catch (e) {
          Navigator.pop(context);
          displayMessageToUser(e.code, context);
        }
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lütfen bir rol seçin.")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş yapılamadı: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "KARABAŞ OTOMOTİV",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "E-posta",
                    labelStyle: TextStyle(color: Colors.brown),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 2.0),
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.brown),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.brown),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Şifre",
                    labelStyle: TextStyle(color: Colors.brown),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 2.0),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.brown),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.brown),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Rol Seçin",
                    labelStyle: TextStyle(color: Colors.brown),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 2.0),
                    ),
                  ),
                  value: selectedRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRole = newValue;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "Şirket Sahibi",
                      child: Text(
                        "Şirket Sahibi",
                        style: TextStyle(color: Colors.brown),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Müşteri",
                      child: Text(
                        "Müşteri",
                        style: TextStyle(color: Colors.brown),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: login,
                  child: const Text("Giriş Yap"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    "Hesabınız yok mu? Kayıt Olun",
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
