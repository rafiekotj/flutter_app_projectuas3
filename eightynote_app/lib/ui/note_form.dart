import 'package:flutter/material.dart';
import '../model/note.dart';
import '../service/note_service.dart';
import 'note_detail.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({Key? key}) : super(key: key);

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _titlesCtrl = TextEditingController();
  final _contentsCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 96, 16, 0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [_fieldTitleNote(), _fieldContentNote()],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Note note =
              Note(titles: _titlesCtrl.text, contents: _contentsCtrl.text);
          await NoteService().simpan(note).then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteDetail(note: value)));
          });
        },
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 22, 6, 6),
        child: const Icon(Icons.save),
      ),
    );
  }

  _fieldTitleNote() {
    return TextField(
      controller: _titlesCtrl,
      style: const TextStyle(color: Colors.white, fontSize: 30),
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
    );
  }

  _fieldContentNote() {
    return TextField(
      controller: _contentsCtrl,
      style: const TextStyle(
        color: Colors.white,
      ),
      maxLines: null,
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something here',
          hintStyle: TextStyle(
            color: Colors.grey,
          )),
    );
  }
}
