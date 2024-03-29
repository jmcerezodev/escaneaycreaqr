import 'dart:convert';
//import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';

ScanModel scanModeFromJson(String str) => ScanModel.fromJson(json.decode(str));

String scanModeToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
  ScanModel({
    this.id,
    this.tipo,
    @required this.valor,
  }){

    if(this.valor.contains('http')){
      this.tipo = 'http';
    }else{
      this.tipo = 'geo';
    }
  }

  int id;
  String tipo;
  String valor;

  // LatLng getLatLng(){
  //
  //   final latLng = this.valor.substring(0).split(',');
  //   final lat = double.parse(latLng[0]);
  //   final lng = double.parse(latLng[1]);
  //   print('Latitud y Longitud : $latLng');
  //
  //   return LatLng(lat, lng);
  // }

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
    id: json["id"],
    tipo: json["tipo"],
    valor: json["valor"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tipo": tipo,
    "valor": valor,
  };
}