//import 'dart:convert';
import 'package:demo_probador_virtual/pages/home_page.dart';
import 'package:flutter/material.dart';
import '/widgets/dni_input_dialog.dart';
import '/widgets/product_item.dart';
import '/services/number_request_dni.dart';

class CartPage extends StatefulWidget{
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>{
  var _resultConsultaDni = '';

  @override
  void initState() {
    super.initState();
    // Cargar peticiones restantes de consulta DNI después de la construcción inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDataNumerConsultDNI();
    });
  }

  Future<void> _fetchDataNumerConsultDNI() async {
    var response = await NumberRequestService.fetchNumberRequestData(context);
    print('RESPONSE CART_PAGE: $response');

    if (response != null) {
      var subscription = response['subscription'];
      var totalRequests = subscription != null ? subscription['number_of_requests'] : null;
      var usedRequests = response['total_requests'];

      if (totalRequests != null && usedRequests != null) {
        int queryRequests = totalRequests - usedRequests;
        setState(() {
          _resultConsultaDni = 'Quedan $queryRequests consultas de DNI restantes.';
        });
      } else {
        print('Error: totalRequests o usedRequests son null');
        Navigator.of(context).pop();
      }
    } else {
      // Intentar con un nuevo token y volver a llamar a la API
      var newResponse = await NumberRequestService.fetchNumberRequestData(context);
      if (newResponse != null) {
        var subscription = newResponse['subscription'];
        var totalRequests = subscription != null ? subscription['number_of_requests'] : null;
        var usedRequests = newResponse['total_requests'];

        if (totalRequests != null && usedRequests != null) {
          int queryRequests = totalRequests - usedRequests;
          setState(() {
            _resultConsultaDni = 'Quedan $queryRequests consultas de DNI restantes.';
          });
        } else {
          print('Error: totalRequests o usedRequests son null');
          Navigator.of(context).pop();
        }
      } else {
        print('REGRESANDO AL INICIO-ERROR');
        Navigator.of(context).pop();
      }
    }
  }
  
  void _showDniInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DniInputDialog(
          onConfirm: (String dni) {
            // Aquí puedes manejar la lógica cuando se confirma el DNI
            print('DNI ingresado: $dni');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            //Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          },
        ),
        title: const Text('Carrito de Compras'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ejemplo de uso de ProductItem reutilizable
            ProductItem(
              productName: 'Casaca Jean Negra Talla M',
              imageUrl: 'product1.jpg',
            ),
            const SizedBox(height: 18.0),
            ProductItem(
              productName: 'Polo Cuello Camisa Talla M',
              imageUrl: 'product2.jpg',
            ),
            const SizedBox(height: 20.0),
            // Botones de cancelar y continuar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyHomePage()),
                    );
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showDniInputDialog(context);
                  },
                  child: const Text('Continuar'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            // Resultado de la consulta
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: Text(
                    _resultConsultaDni,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}