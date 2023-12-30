import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        const Text('Sign up to PortaNote', textAlign: TextAlign.center, style: TextStyle(fontSize: 48, height: 0.9)),
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
            print("hi");
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
}
