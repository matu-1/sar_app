import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SolicitudProvider {
  final _url = 'http://192.168.0.14/proySaar/public/api/solicitud';

  Future<List> getAll() async {
    try {
      final response = await http.get(_url);  // cuando no hay conexion lanza una exception de tipo socket x lo q el try - catch lo captura 
      if(response?.statusCode == 200) {  //respuesta ok  
        final data = json.decode(response.body); print(data);
        return data;
      } else {
        throw Exception('No se pudo cargar las solicitudes');
      }
    } catch (e) {
      throw Exception('No hay conexion!!');
    }
  }

  Future<bool> create(Map solicitud) async {
    solicitud['detalles'] = solicitud['detalles'].map((detalle){
      detalle['foto'] = getImageBase64(detalle['foto']);
      return detalle;
    }).toList();

    final resp = await http.post(_url, 
    body: json.encode(solicitud), 
    headers: {  
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    final data = json.decode(resp.body);
    solicitud['sol_fecha_devolucion'] = "se cambio el valro";
    print(data);
    return true;
  }

  String getImageBase64(File imagen) {
    final bytes = imagen.readAsBytesSync();
    String img64 =  base64Encode(bytes); 
    return 'data:image/jpeg;base64,' + img64;
  }

  Future<String> subirImagen(File imagen) async {
    final url = 'https://api.cloudinary.com/v1_1/dugc89lbj/image/upload';
    final uploadPreset = 'mnzfvfae';
    final bytes = imagen.readAsBytesSync();
    String img64 =  base64Encode(bytes); 
    // print('base64: ' + img64);
    final resp = await http.post(url, body: {
      'file': 'data:image/jpeg;base64,' + img64,
      'upload_preset': uploadPreset,
    });
    final data = json.decode(resp.body);
    print(data);
    return data["secure_url"];
  }

}