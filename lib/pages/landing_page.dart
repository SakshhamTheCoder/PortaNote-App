import 'package:flutter/material.dart';
import 'package:portanote_app/components/default_scaffold.dart';
import 'package:portanote_app/pages/signup_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome to PortaNote',
            style: TextStyle(fontSize: 48, height: 1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text('A note-taking app accessible on the go'),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
            },
            child: const Text('Get Started'),
          ),
        ],
      ),
    ));
  }
}
