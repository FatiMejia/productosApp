import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService extends ChangeNotifier{
 
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseKey = 'AIzaSyCXJP2sKdgG06JNtDDzA_323i8Sbxcof9w';

  //metodo para crear un usuario
  Future<String?> crearUsuario (String email, String password)async{
    final Map<String,dynamic> authData = {
      'email' : email,
      'password' : password
    };

    final url = 
    Uri.https(_baseUrl, '/v1/accounts:signUp', {'key':_firebaseKey});
    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);

    if(decodedResp.containsKey('idToken')){
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }


  //metodo para iniciar Sesion
  Future<String?> login (String email, String password)async{
    final Map<String,dynamic> authData = {
      'email' : email,
      'password' : password
    };

    final url = 
    Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {'key':_firebaseKey});
    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);

    if(decodedResp.containsKey('idToken')){
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }
}