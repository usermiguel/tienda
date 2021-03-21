import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyCh4yT-uClwNWbKUPcA4tyDIJxYfKsGafQ';

  final _prefs = new PreferenciasUsuario();

  ////
  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
    };

    String bodyF = jsonEncode(authData);

    final resp = await http.post(
      'https://saul-backend.herokuapp.com/api/users/auth/signin',
      //body: json.encode(authData),

      body: bodyF,
      // headers: {
      //   "accept": "application/json",
      //   "content-type": "application/json"
      // },
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (resp.statusCode == 200) {
      return {'ok': true, 'token': decodedResp['token']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['status']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnScureToken': true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData),
    );
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }
}
