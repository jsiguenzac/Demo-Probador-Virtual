import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/widgets/custom_dialog.dart';
import '/widgets/overlay_dialog.dart';
import '/utils/constants.dart';
import '/utils/token.dart';
import '/main.dart';

class NumberRequestService {

  static Future<dynamic> fetchNumberRequestData(BuildContext context) async {
    String url = '${urlBaseMap['authUser']}_api/users/profile';
    final currentContext = MyApp.navigatorKey.currentContext;

    // Mostrar carga en pantalla
    showLoadingDialog();

    try {
      final token = await Token.getAndSaveToken();
      print('TokenCONSULTA_REQUEST_DNI: $token');
      if (token == null) {
        throw Exception('Error al obtener el token');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      hideLoadingDialog();
      print('RESPONSE_requestDNI: ${response.statusCode}');
      if (response.statusCode == 200) {
        // Decodificar la respuesta como UTF-8
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedResponse);

        // Devolver datos recibidos
        return data; //response.body;
      } else if (response.statusCode == 401) {
        // Token no válido, limpiar y reintentar
        Token.clearToken();
        showCustomDialog(currentContext!, 'Sesión expirada. Reinicie la app.');
        return null;
      } else {
        // Otro error en la respuesta
        showCustomDialog(currentContext!, 'Error al obtener los datos. Inténtalo de nuevo.');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      hideLoadingDialog();
      showCustomDialog(currentContext!, 'Error al conectarse al servidor. Inténtalo de nuevo.');
      return null;
    }
  }
}