//import 'dart:convert';
import 'package:flutter/material.dart';
import '/pages/cart_page.dart';

void showUserDataModal(BuildContext context, dynamic userData) {
  print('userData: $userData');
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Información obtenida'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DNI: ${userData['numeroDocumento']}'),
            Text(
              'Nombre: ${userData['nombres']} ${userData['apellidoPaterno']} ${userData['apellidoMaterno']}'
            ),
            //Text('Dirección: ${userData['address']}'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              //Navigator.of(context).pop();
              // volver a recargar la página
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

void showAlertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
