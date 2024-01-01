import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portanote_app/components/default_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portanote_app/pages/create_page.dart';
import 'package:portanote_app/pages/view_edit_page.dart';

import 'signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  void signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      trailingWidget: IconButton(
        onPressed: () {
          AlertDialog alert = AlertDialog(
            title: const Text("Sign Out"),
            content: const Text("Are you sure you want to sign out?"),
            actions: [
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  signOut();
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(builder: (context) => const SignInPage()), (route) => false);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signed out')));
                },
              ),
              TextButton(
                child: const Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
          showDialog(context: context, builder: (BuildContext context) => alert);
        },
        icon: const Icon(Icons.logout),
        tooltip: "Sign Out",
      ),
      body: Center(
          child: Column(
        children: [
          Text('Welcome ${auth.currentUser!.email}'),
          const SizedBox(height: 16),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(FirebaseAuth.instance.currentUser!.uid.toString())
                .orderBy("date", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('Loading notes...'));
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Expanded(
                  child: Center(
                      child: Text('No notes found. Create one using the Create Button below',
                          textAlign: TextAlign.center, style: TextStyle(fontSize: 24))),
                );
              }
              return Expanded(
                child: GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 5 / 6),
                  // return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewEditPage(noteId: snapshot.data!.docs[index].id.toString())));
                        },
                        child: Stack(
                            fit: StackFit.expand,
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          snapshot.data?.docs[index]['title'],
                                          style: const TextStyle(fontSize: 24),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          snapshot.data?.docs[index]['content'],
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyyy HH:mm:ss')
                                          .format(snapshot.data!.docs[index]['date'].toDate())
                                          .toString(),
                                      style: const TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    AlertDialog alert = AlertDialog(
                                      title: const Text("Delete Note"),
                                      content: const Text("Are you sure you want to delete this note?"),
                                      actions: [
                                        TextButton(
                                          child: const Text("Yes"),
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection(FirebaseAuth.instance.currentUser!.uid.toString())
                                                .doc(snapshot.data!.docs[index].id.toString())
                                                .delete();
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(content: Text('Note deleted')));
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("No"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                    showDialog(context: context, builder: (BuildContext context) => alert);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              )
                            ]),
                      ),
                    );
                  },
                  itemCount: snapshot.data?.docs.length,
                ),
              );
            },
          )
        ],
      )),
      fab: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePage()));
        },
        label: const Text('Create Note'),
        icon: const Icon(Icons.create),
      ),
    );
  }
}
