//import 'dart:js_interop_unsafe';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_dialog.dart';
import '/widgets/camera_view.dart';
import '/pages/cart_page.dart';
import '/utils/token.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  final String title = 'TIRANDO FACHA';
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Obtiene la lista de cámaras disponibles en el dispositivo.
      cameras = await availableCameras();
      // Filtra la cámara para obtener la cámara frontal.
      CameraDescription frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      // Inicializa el CameraController con la cámara frontal.
      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
      );
      await cameraController.initialize();
      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      print('Error al iniciar la cámara: $e');
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _navigateToCartPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }

  void _onPressed(BuildContext context) async {
    var tk = await Token.getAndSaveToken();
    if (tk != null && tk.isNotEmpty) {
      print('TokenGENERADO: $tk');
      _navigateToCartPage(context);
    } else {
      showCustomDialog(context, 'Error al obtener el token. Intente más tarde.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // tamaño de la barra de navegación
        child: AppBar(
          backgroundColor:Colors.black, //Colors.orange[700],  //Theme.of(context).colorScheme.inversePrimary,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40.0), // margen superior
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.jpg',
                  width: 100,
                  height: 50,
                ),
                const SizedBox(width: 15), // Espacio entre la imagen y el texto
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    // tipo de letra
                    fontFamily: 'Georgia',
                    color: Colors.orange[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          isCameraInitialized
              ? Positioned.fill(child: CameraView(cameraController: cameraController))
              : const Center(child: CircularProgressIndicator()),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        // Image.asset(
                        //   'assets/images/logo.jpg',
                        //   width: 800,
                        //   height: 100,
                        // ),
                        Text(
                          'Probador Virtual',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                      ],                    
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          icon: Icons.adf_scanner_sharp,
                          label: 'ESCANEARME',
                          onPressed: () {
                            // definir la funcionalidad onPressed aquí
                            showCustomDialog(context, 'Esta funcionalidad aún está en desarrollo.');                            
                          },
                        ),
                        CustomButton(
                          icon: Icons.shopping_cart,
                          label: 'CARRITO',
                          onPressed: () {
                            // definir la funcionalidad onPressed aquí
                            _onPressed(context);
                            //_navigateToCartPage(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'DEMO - ENTREGABLE',
                    style: TextStyle(fontSize: 24, color: Colors.orange[300]),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
