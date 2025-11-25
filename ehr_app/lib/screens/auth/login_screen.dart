import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool loading = false;
  String? errorMsg;

  Future<void> login() async {
    setState(() {
      loading = true;
      errorMsg = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => errorMsg = e.message);
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng nhập EHR")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            if (errorMsg != null) 
              Text(errorMsg!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: loading ? null : login,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Đăng nhập"),
            ),
          ],
        ),
      ),
    );
  }
}
