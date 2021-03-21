// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

ProductoModel productoModelFromJson(String str) =>
    ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  String id;
  String titulo;
  double valor;
  bool disponible;
  String fotoUrl;
  String fotoId;

  ProductoModel({
    this.id,
    this.titulo = '',
    this.valor = 0.0,
    this.disponible = true,
    this.fotoUrl,
    this.fotoId,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) =>
      new ProductoModel(
          id: json["_id"],
          titulo: json["name"],
          valor: json["price"].toDouble(),
          disponible: true,
          fotoUrl: json["imageURL"],
          fotoId: json["public_id"]);

  Map<String, dynamic> toJson() => {
        // "id"         : id,
        "titulo": titulo,
        "valor": valor,
        "disponible": disponible,
        "fotoUrl": fotoUrl,
        "fotoId": fotoId
      };
}
