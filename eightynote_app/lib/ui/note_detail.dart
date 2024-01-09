import 'package:flutter/material.dart';
import '../model/note.dart';
import 'note_page.dart';
import 'note_update_form.dart';
import '../service/note_service.dart';

class NoteDetail extends StatefulWidget {
  final Note note;

  const NoteDetail({Key? key, required this.note}) : super(key: key);

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  Stream<Note> getData() async* {
    Note data = await NoteService().getById(widget.note.id.toString());
    yield data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: StreamBuilder(
          stream: getData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return const Text('Data Tidak Ditemukan');
            }

            return Padding(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                child: Column(children: [
                  // HEADER --------------------

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const NotePage()));
                          },
                          padding: const EdgeInsets.all(0),
                          icon: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade800.withOpacity(.8),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                          )),
                      Row(
                        children: [
                          _updateButton(),
                          const SizedBox(width: 10),
                          IconButton(
                              onPressed: () {
                                _deleteButton();
                              },
                              padding: const EdgeInsets.all(0),
                              icon: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade800.withOpacity(.8),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // NOTE CONTENT --------------------

                  Expanded(
                      child: ListView(
                    children: [
                      TextField(
                        readOnly: true,
                        controller: TextEditingController(
                            text: "${snapshot.data.titles}"),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 30),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 30)),
                      ),
                      TextField(
                        readOnly: true,
                        controller: TextEditingController(
                            text: "${snapshot.data.contents}"),
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
                      ),
                    ],
                  ))
                ]));
          }),
    );
  }

  _updateButton() {
    return StreamBuilder(
      stream: getData(),
      builder: (context, AsyncSnapshot snapshot) => IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteUpdateForm(note: snapshot.data)));
          },
          padding: const EdgeInsets.all(0),
          style: IconButton.styleFrom(backgroundColor: Colors.green),
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.grey.shade800.withOpacity(.8),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          )),
    );
  }

  _deleteButton() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text('Are you sure you want to delete?'),
      actions: [
        StreamBuilder(
            stream: getData(),
            builder: (context, AsyncSnapshot snapshot) => ElevatedButton(
                  onPressed: () async {
                    await NoteService().hapus(snapshot.data).then((value) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotePage()));
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("YA"),
                )),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text("Tidak"),
        )
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }
}
