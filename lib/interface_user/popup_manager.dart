import 'package:flutter/material.dart';


class PopupManager {
  static void showPopup(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = _createOverlayEntry(context, message);
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 1), () {
      overlayEntry.remove();
    });
  }

  static OverlayEntry _createOverlayEntry(BuildContext context, String message) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 3,
        left: MediaQuery.of(context).size.width / 4,
        width: MediaQuery.of(context).size.width / 2,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void showEsconderMessage(BuildContext context, VoidCallback onCancel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Escolha uma carta para esconder ou clique em cancelar'),
        action: SnackBarAction(
          label: 'Cancelar',
          onPressed: onCancel,
        ),
      ),
    );
  }

  
  void mostrarPopup(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 3,
        left: MediaQuery.of(context).size.width / 4,
        width: MediaQuery.of(context).size.width / 2,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}

