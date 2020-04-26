import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sar_app/src/utils/utils.dart' as utils;

class SolicitudProvider {
  final _url = 'http://192.168.0.14/proySaar/public/api/solicitud';

  Future<List> getAll() async {
    final resp = await http.get(_url);
    final data = json.decode(resp.body);
    print(data);
    return data;
  }

  Future<bool> create(Map solicitud) async {
    Map datos = {
      'sol_fecha_entrega': utils.getFechaActual(),
      'sol_fecha_devolucion': solicitud["fechaDevolucionTexto"],
      'sol_observaciones_entrega': solicitud["observacion"],
      'sol_per_id': solicitud["idPersona"],
      'detalles': solicitud["detalles"]
    };
    final resp = await http.post(_url, body: json.encode(datos));
    final data = json.decode(resp.body);
    print(data);
    return true;
  }

}