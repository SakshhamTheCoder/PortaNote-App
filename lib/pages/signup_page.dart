import 'package:flutter/material.dart';

import '../components/default_scaffold.dart';
import 'signin_page.dart';

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
            print("hi");
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
}
