import 'dart:convert';
import 'package:http/http.dart' as http;
import '/widgets/custom_dialog.dart';
import '/widgets/overlay_dialog.dart';
import '/utils/constants.dart';
import '/main.dart';

class LoginService {
  static Future<dynamic> fetchLogin() async {
    var context = MyApp.navigatorKey.currentContext!;
    String url = '${urlBaseMap['authUser']}_api/users/login';
    var body = jsonEncode(<String, String>
    {
      'username': 'TU_USERNAME',
      'password': 'TU_PASSWORD'
    });
    // Mostrar carga en pantalla
    showLoadingDialog();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Cerrar modal de carga
        hideLoadingDialog();
        // Devolver datos recibidos
        return response.body;
      } else {
        // Cerrar modal de carga en caso de error
        hideLoadingDialog();
        showCustomDialog(context, 'Error al obtener los datos de logueo.');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      // Cerrar modal de carga en caso de excepción
      hideLoadingDialog();
      showCustomDialog(context, 'Error al conectarse al servidor de logueo.');
      return null;
    }
  }
}