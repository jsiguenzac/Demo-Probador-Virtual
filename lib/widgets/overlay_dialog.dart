import 'package:flutter/material.dart';
import '/widgets/loading_dialog.dart'; 
import '/main.dart';

OverlayEntry? _loadingOverlayEntry;

void showLoadingDialog() {
  if (_loadingOverlayEntry != null) return; // Evita mostrar múltiples instancias

  _loadingOverlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return const LoadingDialog();
    },
  );

  final overlay = MyApp.navigatorKey.currentState?.overlay;
  if (overlay != null) {
    overlay.insert(_loadingOverlayEntry!);
  }
}

void hideLoadingDialog() {
  _loadingOverlayEntry?.remove();
  _loadingOverlayEntry = null;
}
