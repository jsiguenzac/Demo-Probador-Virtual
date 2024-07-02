import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/widgets/custom_dialog.dart';
import '/widgets/overlay_dialog.dart';
import '/widgets/data_user_dialog.dart';
import '/utils/constants.dart';

class DniService {
  static const String bearerToken = tokenConsultDNI;

  static Future<String?> fetchDniData(BuildContext context, String dni) async {
    String url = '${urlBaseMap['urlBaseDNI']}v2/reniec/dni?numero=$dni';
    print('Token_BEARER_DNI: $bearerToken');
    // Mostrar carga en pantalla
    showLoadingDialog();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('Response FECHT_DNI_SERVICE: ${response.body}');
      print('Response FECHT_DNI_SERVICE_Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        // Decodificar la respuesta como UTF-8
        final decodedResponse = utf8.decode(response.bodyBytes);
        final userData = jsonDecode(decodedResponse);

        // Mostrar información recibida en otro modal
        showUserDataModal(context, userData);
        // Cerrar modal de carga
        hideLoadingDialog();

        // Devolver datos recibidos
        return response.body;
      } else {
        // Cerrar modal de carga en caso de error
        hideLoadingDialog();
        showCustomDialog(context, 'Error al obtener los datos.\n Inténtalo de nuevo.');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      // Cerrar modal de carga en caso de excepción
      hideLoadingDialog();
      showCustomDialog(context, 'Error al conectarse al servidor.\n Inténtalo de nuevo.');
      return null;
    }
  }
}
