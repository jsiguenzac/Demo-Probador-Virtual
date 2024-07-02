import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '/services/login_dni_service.dart';

class Token {
  static const _storage = FlutterSecureStorage();

  static Future<String?> getAndSaveToken() async {
    try {
      // Leer el token almacenado
      var token = await _storage.read(key: 'token');
      print("TokenGetSave: $token");

      // Si el token existe y no está vacío, retornarlo
      if (token != null && token.isNotEmpty) {
        return token;
      } else {
        // Obtener un nuevo token del servicio de login
        var response = await LoginService.fetchLogin();
        print("TokenGetSaveAWAIT: $response");
        // Decodificar la respuesta JSON
        var keyToken = jsonDecode(response);

        print("TokenGetSaveAWAIT: $keyToken");

        // Verificar que el keyToken no sea nulo y contenga el 'access_token'
        if (keyToken != null && keyToken is Map && keyToken.containsKey('access_token')) {
          token = keyToken['access_token'];
          await _storage.write(key: 'token', value: token);
          return token;
        } else {
          print('Error: Respuesta de login no contiene el token esperado');
        }
      }
    } catch (e) {
      print('Error al obtener o guardar el token: $e');
    }
    print('RETURN NULL:v');
    return null;
  }

  static Future<void> clearToken() async {
    try {
      await _storage.delete(key: 'token');
    } catch (e) {
      print('Error al limpiar el token: $e');
    }
  }
}