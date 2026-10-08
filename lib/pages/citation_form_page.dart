import 'package:citacoes_app/models/citation.dart';
import 'package:citacoes_app/pages/result_page.dart';
import 'package:citacoes_app/widgets/citation_field.dart';
import 'package:flutter/material.dart';

class CitationFormPage extends StatefulWidget {
  final String tipo;

  const CitationFormPage({
    super.key,
    required this.tipo,
  });

  @override
  State<CitationFormPage> createState() => _CitationFormPageState();
}

class _CitationFormPageState extends State<CitationFormPage> {
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _editoraController = TextEditingController();
  final TextEditingController _revistaController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  bool _showErrorMessage = false;

  bool _hasEmptyRequiredFields() {
    if (widget.tipo == 'Livro') {
      return _autorController.text.trim().isEmpty ||
          _tituloController.text.trim().isEmpty ||
          _editoraController.text.trim().isEmpty ||
          _anoController.text.trim().isEmpty;
    }

    if (widget.tipo == 'Artigo') {
      return _autorController.text.trim().isEmpty ||
          _tituloController.text.trim().isEmpty ||
          _revistaController.text.trim().isEmpty ||
          _anoController.text.trim().isEmpty;
    }

    return _autorController.text.trim().isEmpty ||
        _tituloController.text.trim().isEmpty ||
        _urlController.text.trim().isEmpty ||
        _anoController.text.trim().isEmpty;
  }

  void _generateReference() {
    setState(() {
      _showErrorMessage = _hasEmptyRequiredFields();
    });

    if (_showErrorMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatórios.'),
        ),
      );
      return;
    }

    final citation = Citation(
      tipo: widget.tipo,
      autor: _autorController.text.trim(),
      titulo: _tituloController.text.trim(),
      editora: _editoraController.text.trim(),
      revista: _revistaController.text.trim(),
      url: _urlController.text.trim(),
      ano: _anoController.text.trim(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(citation: citation),
      ),
    );
  }

  List<Widget> _buildFields() {
    if (widget.tipo == 'Livro') {
      return [
        CitationField(
          label: 'Autor',
          hint: 'Ex.: João Silva',
          controller: _autorController,
        ),
        CitationField(
          label: 'Título',
          hint: 'Ex.: Introdução à Computação',
          controller: _tituloController,
        ),
        CitationField(
          label: 'Editora',
          hint: 'Ex.: Editora Exemplo',
          controller: _editoraController,
        ),
        CitationField(
          label: 'Ano',
          hint: 'Ex.: 2024',
          controller: _anoController,
          keyboardType: TextInputType.number,
        ),
      ];
    }

    if (widget.tipo == 'Artigo') {
      return [
        CitationField(
          label: 'Autor',
          hint: 'Ex.: João Silva',
          controller: _autorController,
        ),
        CitationField(
          label: 'Título do artigo',
          hint: 'Ex.: Introdução à Computação',
          controller: _tituloController,
        ),
        CitationField(
          label: 'Nome da revista',
          hint: 'Ex.: Revista de Computação',
          controller: _revistaController,
        ),
        CitationField(
          label: 'Ano',
          hint: 'Ex.: 2024',
          controller: _anoController,
          keyboardType: TextInputType.number,
        ),
      ];
    }

    return [
      CitationField(
        label: 'Autor/Organização',
        hint: 'Ex.: Universidade Exemplo',
        controller: _autorController,
      ),
      CitationField(
        label: 'Título da página',
        hint: 'Ex.: Introdução à Computação',
        controller: _tituloController,
      ),
      CitationField(
        label: 'URL',
        hint: 'https://www.exemplo.com',
        controller: _urlController,
        keyboardType: TextInputType.url,
      ),
      CitationField(
        label: 'Ano',
        hint: 'Ex.: 2024',
        controller: _anoController,
        keyboardType: TextInputType.number,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Preencher dados do ${widget.tipo}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ..._buildFields(),
              if (_showErrorMessage)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Preencha todos os campos obrigatórios.',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _generateReference,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'GERAR REFERÊNCIA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _autorController.dispose();
    _tituloController.dispose();
    _editoraController.dispose();
    _revistaController.dispose();
    _urlController.dispose();
    _anoController.dispose();
    super.dispose();
  }
}
