import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/default_scaffold.dart';
import 'home_page.dart';
import 'signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        body: Center(
            child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        const Text('Sign in to PortaNote', textAlign: TextAlign.center, style: TextStyle(fontSize: 48, height: 0.9)),
        const SizedBox(height: 32),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            labelText: 'Email',
            hintText: 'user@email.com',
            isDense: true,
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            labelText: 'Password',
            hintText: '••••••••',
            isDense: true,
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () async {
            _signInFirebase(_emailController.value.text, _passwordController.value.text);
          },
          child: const Text('Sign in'),
        ),
        const SizedBox(height: 16),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
            },
            child: const Text('Create Account'))
      ]),
    )));
  }

  void _signInFirebase(String email, String password) {
    // try {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }).catchError((e) {
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Invalid credentials. Please enter correct email/password.')));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid email.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
      }
    });

    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    //   }
    // });
    // } on FirebaseAuthException catch (e) {
    //   // if (e.code == 'user-not-found') {
    //   //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No user found for that email.')));
    //   // } else if (e.code == 'wrong-password') {
    //   //   ScaffoldMessenger.of(context)
    //   //       .showSnackBar(const SnackBar(content: Text('Wrong password provided for that user.')));
    //   // } else {
    //   //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
    //   // }
    //   print(e.code);
    // }
  }
}
