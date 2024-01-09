import 'package:dio/dio.dart';
import '../helpers/api_client.dart';
import '../model/note.dart';

class NoteService {
  Future<List<Note>> listData() async {
    final Response response = await ApiClient().get('note');
    final List data = response.data as List;
    List<Note> result = data.map((json) => Note.fromJson(json)).toList();
    return result;
  }

  Future<Note> simpan(Note note) async {
    var data = note.toJson();
    final Response response = await ApiClient().post('note', data);
    Note result = Note.fromJson(response.data);
    return result;
  }

  Future<Note> ubah(Note note, String id) async {
    var data = note.toJson();
    final Response response = await ApiClient().put('note/${id}', data);
    Note result = Note.fromJson(response.data);
    return result;
  }

  Future<Note> getById(String id) async {
    final Response response = await ApiClient().get('note/${id}');
    Note result = Note.fromJson(response.data);
    return result;
  }

  Future<Note> hapus(Note note) async {
    final Response response = await ApiClient().delete('note/${note.id}');
    Note result = Note.fromJson(response.data);
    return result;
  }
}
