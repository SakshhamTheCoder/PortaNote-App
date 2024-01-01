import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portanote_app/components/default_scaffold.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
            child: Column(
          children: [
            Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    labelText: 'Title',
                    hintText: 'Title',
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 10,
                  maxLines: null,
                  controller: _contentController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    labelText: 'Content',
                    hintText: 'Content',
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            )
          ],
        )),
      ),
      fab: FloatingActionButton.extended(
        onPressed: () {
          var title = _titleController.value.text.trim();
          var content = _contentController.value.text.trim();
          if (title == '' && content == '') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note cannot be empty')));
            return;
          }
          FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid.toString()).doc().set({
            'title': title,
            'content': content,
            'date': DateTime.now(),
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note created')));
        },
        label: const Text('Save Note'),
        icon: const Icon(Icons.save_as),
      ),
    );
  }
}
