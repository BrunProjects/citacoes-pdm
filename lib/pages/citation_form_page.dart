import 'package:citacoes_app/models/citation.dart';
import 'package:citacoes_app/pages/result_page.dart';
import 'package:citacoes_app/widgets/citation_field.dart';
import 'package:flutter/material.dart';

class CitationFormPage extends StatefulWidget {
  final String tipo;

  const CitationFormPage({super.key, required this.tipo});

  @override
  State<CitationFormPage> createState() => _CitationFormPageState();
}

class _CitationFormPageState extends State<CitationFormPage> {
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _editoraController = TextEditingController();
  final TextEditingController _revistaController = TextEditingController();
  final TextEditingController _subtituloArtigoController =
      TextEditingController();
  final TextEditingController _subtituloRevistaController =
      TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _fasciculoController = TextEditingController();
  final TextEditingController _paginaInicialController =
      TextEditingController();
  final TextEditingController _paginaFinalController = TextEditingController();
  final TextEditingController _mesController = TextEditingController();
  final TextEditingController _doiController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nomeSiteController = TextEditingController();
  final TextEditingController _acessoController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  final TextEditingController _paginaController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  bool _showErrorMessage = false;
  bool _artigoOnline = true;

  @override
  void initState() {
    super.initState();
    _acessoController.text = _formatAccessDate(DateTime.now());
  }

  String _formatAccessDate(DateTime date) {
    const months = [
      'jan.',
      'fev.',
      'mar.',
      'abr.',
      'maio',
      'jun.',
      'jul.',
      'ago.',
      'set.',
      'out.',
      'nov.',
      'dez.',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  bool _hasEmptyRequiredFields() {
    final hasNoAuthor = Citation.formatAuthor(_autorController.text).isEmpty;

    if (widget.tipo == 'Livro') {
      return hasNoAuthor ||
          _tituloController.text.trim().isEmpty ||
          _localController.text.trim().isEmpty ||
          _editoraController.text.trim().isEmpty ||
          _anoController.text.trim().isEmpty;
    }

    if (widget.tipo == 'Artigo') {
      return hasNoAuthor ||
          _tituloController.text.trim().isEmpty ||
          _revistaController.text.trim().isEmpty ||
          _localController.text.trim().isEmpty ||
          _volumeController.text.trim().isEmpty ||
          _fasciculoController.text.trim().isEmpty ||
          _paginaInicialController.text.trim().isEmpty ||
          _paginaFinalController.text.trim().isEmpty ||
          _anoController.text.trim().isEmpty ||
          (_artigoOnline &&
              (_acessoController.text.trim().isEmpty ||
                  (_urlController.text.trim().isEmpty &&
                      _doiController.text.trim().isEmpty)));
    }

    return hasNoAuthor ||
        _tituloController.text.trim().isEmpty ||
        _nomeSiteController.text.trim().isEmpty ||
        _urlController.text.trim().isEmpty ||
        _anoController.text.trim().isEmpty ||
        _acessoController.text.trim().isEmpty;
  }

  void _generateReference() {
    setState(() {
      _showErrorMessage = _hasEmptyRequiredFields();
    });

    if (_showErrorMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }

    final citation = Citation(
      tipo: widget.tipo,
      autor: _autorController.text.trim(),
      titulo: _tituloController.text.trim(),
      editora: _editoraController.text.trim(),
      revista: _revistaController.text.trim(),
      subtituloArtigo: _subtituloArtigoController.text.trim(),
      subtituloRevista: _subtituloRevistaController.text.trim(),
      volume: _volumeController.text.trim(),
      fasciculo: _fasciculoController.text.trim(),
      paginaInicial: _paginaInicialController.text.trim(),
      paginaFinal: _paginaFinalController.text.trim(),
      mes: _mesController.text.trim(),
      doi: _doiController.text.trim(),
      artigoOnline: _artigoOnline,
      url: _urlController.text.trim(),
      nomeSite: _nomeSiteController.text.trim(),
      acesso: _acessoController.text.trim(),
      local: _localController.text.trim(),
      pagina: _paginaController.text.trim(),
      ano: _anoController.text.trim(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultPage(citation: citation)),
    );
  }

  List<Widget> _buildFields() {
    if (widget.tipo == 'Livro') {
      return [
        CitationField(
          label: 'Autores',
          hint: 'Ex.: João Silva, Maria Souza e Ana Lima',
          controller: _autorController,
        ),
        CitationField(
          label: 'Título',
          hint: 'Ex.: Introdução à Computação',
          controller: _tituloController,
        ),
        CitationField(
          label: 'Local de publicação',
          hint: 'Ex.: São Paulo',
          controller: _localController,
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
        _buildOptionalFields(),
      ];
    }

    if (widget.tipo == 'Artigo') {
      return [
        _buildSectionTitle('Campos obrigatórios'),
        CitationField(
          label: 'Autores',
          hint: 'Ex.: João Silva, Maria Souza e Ana Lima',
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
          label: 'Local de publicação (cidade)',
          hint: 'Ex.: São Paulo',
          controller: _localController,
        ),
        CitationField(
          label: 'Volume',
          hint: 'Ex.: 10',
          controller: _volumeController,
          keyboardType: TextInputType.number,
        ),
        CitationField(
          label: 'Fascículo (número)',
          hint: 'Ex.: 2',
          controller: _fasciculoController,
          keyboardType: TextInputType.number,
        ),
        Row(
          children: [
            Expanded(
              child: CitationField(
                label: 'Página inicial',
                hint: 'Ex.: 15',
                controller: _paginaInicialController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CitationField(
                label: 'Página final',
                hint: 'Ex.: 30',
                controller: _paginaFinalController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        CitationField(
          label: 'Ano de publicação',
          hint: 'Ex.: 2024',
          controller: _anoController,
          keyboardType: TextInputType.number,
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _artigoOnline,
          title: const Text('Artigo consultado online'),
          onChanged: (value) {
            setState(() => _artigoOnline = value ?? false);
          },
        ),
        if (_artigoOnline) ...[
          CitationField(
            label: 'URL ou endereço eletrônico',
            hint: 'Ex.: https://revistatec.com',
            controller: _urlController,
            keyboardType: TextInputType.url,
          ),
          CitationField(
            label: 'Acesso em',
            hint: 'Ex.: 8 out. 2026',
            controller: _acessoController,
          ),
        ],
        _buildSectionTitle('Campos opcionais'),
        CitationField(
          label: 'Subtítulo do artigo',
          hint: 'Ex.: desafios pós-pandemia',
          controller: _subtituloArtigoController,
        ),
        CitationField(
          label: 'Subtítulo da revista',
          hint: 'Ex.: Estudos Clínicos',
          controller: _subtituloRevistaController,
        ),
        CitationField(
          label: 'Mês ou período',
          hint: 'Ex.: mar.',
          controller: _mesController,
        ),
        CitationField(
          label: 'DOI',
          hint: 'Ex.: doi.org/10.1234/exemplo',
          controller: _doiController,
          keyboardType: TextInputType.url,
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
        label: 'Nome do Site',
        hint: 'Ex.: Portal G1',
        controller: _nomeSiteController,
      ),
      CitationField(
        label: 'Ano',
        hint: 'Ex.: 2024',
        controller: _anoController,
        keyboardType: TextInputType.number,
      ),
      CitationField(
        label: 'URL',
        hint: 'https://www.exemplo.com',
        controller: _urlController,
        keyboardType: TextInputType.url,
      ),
      CitationField(
        label: 'Acesso em',
        hint: 'Ex.: 8 out. 2026',
        controller: _acessoController,
      ),
    ];
  }

  Widget _buildOptionalFields() {
    return Column(
      children: [
        CitationField(
          label: 'Número da página (opcional)',
          hint: 'Ex.: 25',
          controller: _paginaController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tipo)),
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
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Preencha todos os campos obrigatórios.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    _subtituloArtigoController.dispose();
    _subtituloRevistaController.dispose();
    _volumeController.dispose();
    _fasciculoController.dispose();
    _paginaInicialController.dispose();
    _paginaFinalController.dispose();
    _mesController.dispose();
    _doiController.dispose();
    _urlController.dispose();
    _nomeSiteController.dispose();
    _acessoController.dispose();
    _localController.dispose();
    _paginaController.dispose();
    _anoController.dispose();
    super.dispose();
  }
}
