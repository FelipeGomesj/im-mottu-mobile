import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/comics.dart';

class ComicsRepo{
  Future<List<Comics>> fetchComics ()async{
    final Uri url = Uri.parse('https://gateway.marvel.com:443/v1/public/comics?apikey=1b9e6b2dd74d358926e3b7aade77d80a&ts=1&hash=1180f3641ed576bfa17a4a1afb17ac0a');
    var response = await http.get(url);
    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      return List<Comics>.from(json['data']['results'].map((result) => Comics.fromJson(result)));  //.map((result) => Comics.fromJSON(result)));
    }else {
      throw Exception('Falha ao buscar os quadrinhos.\nSTATUS CODE: ${response.statusCode}');
    }
  }
}