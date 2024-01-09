import 'package:flutter/material.dart';
import '../model/note.dart';
import '../service/note_service.dart';
import 'note_item.dart';
import 'note_form.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Stream<List<Note>> getList() async* {
    List<Note> data = await NoteService().listData();
    yield data;
  }

  List<Note> displayedNotes = [];

  void onSearchTextChanged(String searchText) {
    setState(() {
      displayedNotes = displayedNotes
          .where((note) =>
              note.titles.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Column(children: [
            // HEADER (APP BAR) --------------------

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'EightyNotes',
                  style: TextStyle(
                      fontFamily: "Rock Salt",
                      fontSize: 20,
                      color: Colors.white),
                ),
                IconButton(
                    onPressed: () {},
                    padding: const EdgeInsets.all(0),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(.8),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),

            // HEADER LINE --------------------

            Container(
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
              height: 2,
            ),
            const SizedBox(
              height: 20,
            ),

            // SEARCH BAR --------------------

            TextField(
              onChanged: onSearchTextChanged,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: "Search notes...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                fillColor: Colors.grey.shade800,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // NOTE CARD --------------------
            Expanded(
                child: StreamBuilder(
                    stream: getList(),
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
                        return const Text('Data Kosong');
                      }

                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return NoteItem(note: snapshot.data[index]);
                          });
                    })),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NoteForm()));
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(
          Icons.add,
          size: 38,
        ),
      ),
    );
  }
}
