import 'package:citacoes_app/pages/citation_form_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _goToForm(BuildContext context, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CitationFormPage(tipo: type)),
    );
  }

  Widget _buildTypeButton(BuildContext context, String type) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _goToForm(context, type),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          type.toUpperCase(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Citation Generator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Academic Citation Generator',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Gerador de Citações Acadêmicas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Preencha os dados da fonte para gerar uma referência acadêmica.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                _buildTypeButton(context, 'Livro'),
                const SizedBox(height: 16),
                _buildTypeButton(context, 'Artigo'),
                const SizedBox(height: 16),
                _buildTypeButton(context, 'Site'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
