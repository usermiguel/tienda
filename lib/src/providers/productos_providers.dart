import 'dart:convert';
import 'package:flutter_application_1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_application_1/src/models/product_model.dart';

class ProductosProvider {
  final String _url = 'https://saul-backend.herokuapp.com/api';
  //final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/products';

    final resp = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/products/${producto.id}';
    final bodyf = {
      'name': producto.titulo,
      'price': producto.valor,
    };
    final resp = await http.put(
      url,
      // body: productoModelToJson(producto),
      body: json.encode(bodyf),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    final decodedData = json.decode(resp.body);

    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/products';
    final resp = await http.get(url);

    //final Map<String, dynamic> decodedData = json.decode(resp.body);

    final List<ProductoModel> productos = new List();
    final List<dynamic> decodedData = json.decode(resp.body);

    if (decodedData == null) return [];

    decodedData.forEach((prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      //prodTemp.id = id;

      productos.add(prodTemp);
    });

    // print( productos[0].id );

    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json';
    final resp = await http.delete(url);

    print(resp.body);

    return 1;
  }

  Future<String> subirImagen(File imagen, ProductoModel productop) async {
    final url = Uri.parse('$_url/products/${productop.id}');
    final mimeType = mime(imagen.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest('PUT', url);

    final file = await http.MultipartFile.fromPath('image', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);
    imageUploadRequest.fields['name'] = productop.titulo;
    imageUploadRequest.fields['price'] = productop.valor.toString();
    imageUploadRequest.fields['originalPublicId'] = productop.fotoId;

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];
  }
}
