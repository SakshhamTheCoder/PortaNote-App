import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/default_scaffold.dart';
import 'package:portanote_app/pages/home_page.dart';
import 'package:portanote_app/pages/signin_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        body: Center(
            child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        const Text('Sign up to PortaNote', textAlign: TextAlign.center, style: TextStyle(fontSize: 48, height: 1)),
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
        const SizedBox(height: 8),
        TextField(
          controller: _cPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            labelText: 'Confirm Password',
            hintText: '••••••••',
            isDense: true,
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () async {
            _signUpFirebase(_emailController.value.text, _passwordController.value.text);
          },
          child: const Text('Sign up'),
        ),
        const SizedBox(height: 16),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage()));
            },
            child: const Text('Already have an account? Sign in'))
      ]),
    )));
  }

  void _signUpFirebase(String email, String password) {
    if (password != _cPasswordController.value.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }
    if (password.length < 8) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Password must be at least 8 characters.')));
      return;
    }
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
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
    }).catchError((e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('The account already exists for that email.')));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid email.')));
      } else if (e.code == 'operation-not-allowed') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Email/password accounts are not enabled.')));
      } else if (e.code == 'too-many-requests') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Too many requests. Try again later.')));
      } else if (e.code == 'user-disabled') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('The user account has been disabled by an administrator.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
      }
    });
  }
}
