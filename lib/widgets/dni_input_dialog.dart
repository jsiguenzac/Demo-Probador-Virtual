import 'package:flutter/material.dart';
import '/widgets/custom_dialog.dart';
import '/services/dni_service.dart';
import '/main.dart';

class DniInputDialog extends StatefulWidget {
  final void Function(String dni)? onConfirm;

  const DniInputDialog({super.key, this.onConfirm});

  @override
  _DniInputDialogState createState() => _DniInputDialogState();
}

class _DniInputDialogState extends State<DniInputDialog> {
  late TextEditingController _dniController;

  @override
  void initState() {
    super.initState();
    _dniController = TextEditingController();
  }

  @override
  void dispose() {
    _dniController.dispose();
    super.dispose();
  }

  void _closeModal() {
    Navigator.of(context).pop();
  }

  void _confirm() {
    String dni = _dniController.text.trim();
    if (dni.length > 8 || dni.length < 8) {
      showCustomDialog(context, 'El DNI debe tener 8 dígitos');
    }
    else if (dni.isNotEmpty && dni.length == 8) {
      if (widget.onConfirm != null) {
        widget.onConfirm!(dni);
        // Llamar al servicio para obtener los datos del DNI
        DniService.fetchDniData(MyApp.navigatorKey.currentContext!, dni);
      }
      _closeModal();
    }
    else {
      // Mostrar mensaje de error o hacer algo si el DNI está vacío
      showCustomDialog(context, 'El DNI no puede estar vacío');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ingrese su DNI'),
      content: TextField(
        controller: _dniController,
        decoration: const InputDecoration(
          labelText: 'DNI',
          hintText: 'Ingresar DNI',
        ),
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(
          onPressed: _closeModal,
          child:const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _confirm,
          child: const Text('Continuar'),
        ),
      ],
    );
  }
}
