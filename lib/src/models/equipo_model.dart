// To parse this JSON data, do
//
//     final equipoModel = equipoModelFromJson(jsonString);

import 'dart:convert';

EquipoModel equipoModelFromJson(String str) => EquipoModel.fromJson(json.decode(str));

String equipoModelToJson(EquipoModel data) => json.encode(data.toJson());

class EquipoModel {
    int equId;
    String equCodigo;
    String equNombre;
    String equDescripcion;
    String equFechaAlta;
    String equFechaBaja;
    int equEstado;
    int equFamId;

    EquipoModel({
        this.equId,
        this.equCodigo,
        this.equNombre,
        this.equDescripcion,
        this.equFechaAlta,
        this.equFechaBaja,
        this.equEstado,
        this.equFamId,
    });

    factory EquipoModel.fromJson(Map<String, dynamic> json) => EquipoModel(
        equId: json["equ_id"],
        equCodigo: json["equ_codigo"],
        equNombre: json["equ_nombre"],
        equDescripcion: json["equ_descripcion"],
        equFechaAlta: json["equ_fecha_alta"],
        equFechaBaja: json["equ_fecha_baja"],
        equEstado: json["equ_estado"],
        equFamId: json["equ_fam_id"],
    );

    Map<String, dynamic> toJson() => {
        "equ_id": equId,
        "equ_codigo": equCodigo,
        "equ_nombre": equNombre,
        "equ_descripcion": equDescripcion,
        "equ_fecha_alta": equFechaAlta,
        "equ_fecha_baja": equFechaBaja,
        "equ_estado": equEstado,
        "equ_fam_id": equFamId,
    };
}


class Equipos {
  List<EquipoModel> items = new List();
  
  Equipos();

  Equipos.fromJsonList( List<dynamic> jsonList  ) {
    if ( jsonList == null ) return;
    for ( var item in jsonList  ) {
      final equipo = new EquipoModel.fromJson(item);
      items.add( equipo );
    }
  }

}

