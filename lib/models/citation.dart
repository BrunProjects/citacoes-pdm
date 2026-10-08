class Citation {
  final String tipo;
  final String autor;
  final String titulo;
  final String? editora;
  final String? revista;
  final String? url;
  final String ano;

  Citation({
    required this.tipo,
    required this.autor,
    required this.titulo,
    this.editora,
    this.revista,
    this.url,
    required this.ano,
  });

  String formatAuthor(String author) {
    final text = author.trim();

    if (text.isEmpty) {
      return '';
    }

    if (text.contains(',')) {
      return text;
    }

    final parts = text.split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts.first.toUpperCase();
    }

    final surname = parts.last.toUpperCase();
    final names = parts.sublist(0, parts.length - 1).join(' ');

    return '$surname, $names';
  }

  String generateReference() {
    final authorText = formatAuthor(autor);

    if (tipo == 'Livro') {
      return '$authorText. $titulo. ${editora ?? ''}, $ano.';
    }

    if (tipo == 'Artigo') {
      return '$authorText. $titulo. ${revista ?? ''}, $ano.';
    }

    if (tipo == 'Site') {
      return '${authorText.toUpperCase()}. $titulo. ${url ?? ''}, $ano.';
    }

    return '$authorText. $titulo.';
  }
}
