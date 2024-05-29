import 'package:flutter/material.dart';

class ObterNomesJogadores extends StatefulWidget {
  final Function(List<String>) onNomesSubmit;

  const ObterNomesJogadores({super.key, required this.onNomesSubmit});

  @override
  ObterNomesJogadoresState createState() => ObterNomesJogadoresState();
}

class ObterNomesJogadoresState extends State<ObterNomesJogadores> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }


  void _submit() {
    if (_formKey.currentState!.validate()) {
      List<String> nomes = _controllers.map((controller) => controller.text).toList();
      widget.onNomesSubmit(nomes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Obter Nomes dos Jogadores')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ..._controllers.map((controller) {
                return TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: 'Nome do Jogador'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
