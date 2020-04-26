import 'dart:convert';
import 'package:http/http.dart' as http;

class EquipoProvider {
  final _url = 'http://192.168.0.14/proySaar/public/api/equipo';

  Future<List> getAll() async {
    final resp = await http.get(_url);
    final data = json.decode(resp.body);
    print('Equipos');
    print(data);
    return data;
  }

}