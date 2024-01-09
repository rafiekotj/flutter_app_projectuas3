import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../model/note.dart';
import 'note_detail.dart';

class NoteItem extends StatelessWidget {
  final Note note;

  const NoteItem({super.key, required this.note});

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
          margin: const EdgeInsets.only(bottom: 20),
          color: getRandomColor(),
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: RichText(
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: '${note.titles} \n',
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        height: 1.5),
                    children: [
                      TextSpan(
                        text: note.contents,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.5),
                      )
                    ]),
              ),
            ),
          )),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NoteDetail(note: note)));
      },
    );
  }
}
