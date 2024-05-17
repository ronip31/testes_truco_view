import 'package:flutter/material.dart';

class ObterNomesJogadores extends StatefulWidget {
  final Function(List<String>) onNomesSubmit;

  ObterNomesJogadores({required this.onNomesSubmit});

  @override
  _ObterNomesJogadoresState createState() => _ObterNomesJogadoresState();
}

class _ObterNomesJogadoresState extends State<ObterNomesJogadores> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (index) => TextEditingController());
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
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
      appBar: AppBar(title: Text('Obter Nomes dos Jogadores')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ..._controllers.map((controller) {
                return TextFormField(
                  controller: controller,
                  decoration: InputDecoration(labelText: 'Nome do Jogador'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome';
                    }
                    return null;
                  },
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
