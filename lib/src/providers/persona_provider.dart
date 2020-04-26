import 'dart:convert';
import 'package:http/http.dart' as http;

class PersonaProvider {
  final _url = 'http://192.168.0.14/proySaar/public/api/persona';

  Future<List> getAll() async {
    final resp = await http.get(_url);
    final data = json.decode(resp.body);
    print(data);
    return data;
  }

  Future<Map> login(String email, String password) async {
    final resp = await http.post(_url, body: json.encode({
        'email': email,
        'password': password,
      }));
    final data = json.decode(resp.body);
    print(data);
    return data;
  }

}