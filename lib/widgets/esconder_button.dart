import 'package:flutter/material.dart';

class CorrerButton extends StatelessWidget {
  final VoidCallback onEsconderPressed; // Função que será executada quando o botão for pressionado

  const CorrerButton({super.key, required this.onEsconderPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onEsconderPressed, // Define a função a ser executada quando o botão é pressionado
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Cor de fundo do botão
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding interno do botão
        textStyle: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 0, 0)), // Estilo do texto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas do botão
        ),
        elevation: 5, // Elevação do botão, criando uma sombra
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // O botão se ajusta ao tamanho de seu conteúdo
        children: [
          Icon(Icons.exit_to_app, color: Colors.red[900]), // Ícone de saída com cor vermelha
          const SizedBox(width: 10), // Espaço entre o ícone e o texto
          Text(
            'ESCONDER',
            style: TextStyle(
              color: Colors.red[900], // Cor do texto
              fontSize: 20, // Tamanho da fonte do texto
              fontWeight: FontWeight.bold, // Peso da fonte do texto
            ),
          ),
        ],
      ),
    );
  }
}
