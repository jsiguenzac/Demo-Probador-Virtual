import 'package:flutter/material.dart';
import '/widgets/custom_dialog.dart';

class ProductItem extends StatefulWidget {
  final String productName;
  final String imageUrl;
  //final VoidCallback onDelete;

  ProductItem({
    Key? key,
    required this.productName,
    required this.imageUrl,
    //required this.onDelete,
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int quantity = 1;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: quantity.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  // Función para incrementar la cantidad
  void incrementQuantity() {
    setState(() {
      quantity++;
      _quantityController.text = quantity.toString();
    });
  }

  // Función para decrementar la cantidad
  void decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
        _quantityController.text = quantity.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          // Imagen del producto
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage('assets/images/${widget.imageUrl}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del producto
                Text(
                  widget.productName,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                // Funcionalidad para agregar o restar cantidad
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: decrementQuantity,
                    ),
                    // Input para mostrar la cantidad
                    Expanded(
                      child: TextFormField(
                        controller: _quantityController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            quantity = int.tryParse(value) ?? quantity;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: incrementQuantity,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Botón de eliminación
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showCustomDialog(context, '¿Estás seguro de que deseas eliminar este producto?'),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
