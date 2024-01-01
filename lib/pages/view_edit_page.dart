import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portanote_app/components/default_scaffold.dart';

class ViewEditPage extends StatefulWidget {
  final String noteId;
  const ViewEditPage({super.key, required this.noteId});

  @override
  State<ViewEditPage> createState() => _ViewEditPageState();
}

class _ViewEditPageState extends State<ViewEditPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const Text('View/Edit note', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(FirebaseAuth.instance.currentUser!.uid.toString())
                      .doc(widget.noteId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('Loading note...'));
                    }
                    _titleController.value = TextEditingValue(text: snapshot.data?['title']);
                    _contentController.value = TextEditingValue(text: snapshot.data?['content']);

                    return Column(
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
                    );
                  }),
            ],
          ),
        ),
      ),
      fab: FloatingActionButton.extended(
        onPressed: () {
          var title = _titleController.value.text.trim();
          var content = _contentController.value.text.trim();
          if (title == '' && content == '') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note cannot be empty')));
            return;
          }
          FirebaseFirestore.instance
              .collection(FirebaseAuth.instance.currentUser!.uid.toString())
              .doc(widget.noteId)
              .update({
            'title': title,
            'content': content,
            'date': DateTime.now(),
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note saved')));
        },
        label: const Text('Save Note', style: TextStyle(fontSize: 18)),
        icon: const Icon(Icons.save_as),
      ),
    );
  }
}
