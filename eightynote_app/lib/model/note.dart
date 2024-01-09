class Note {
  String? id;
  String titles;
  String contents;

  Note({
    this.id,
    required this.titles,
    required this.contents,
  });

  factory Note.fromJson(Map<String, dynamic> json) =>
      Note(id: json["id"], titles: json["title"], contents: json["content"]);

  Map<String, dynamic> toJson() => {"title": titles, "content": contents};
}
