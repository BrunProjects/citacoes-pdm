class Citation {
  final String tipo;
  final String autor;
  final String titulo;
  final String? editora;
  final String? revista;
  final String? subtituloArtigo;
  final String? subtituloRevista;
  final String? volume;
  final String? fasciculo;
  final String? paginaInicial;
  final String? paginaFinal;
  final String? mes;
  final String? doi;
  final bool artigoOnline;
  final String? url;
  final String? nomeSite;
  final String? acesso;
  final String? local;
  final String? pagina;
  final String ano;

  Citation({
    required this.tipo,
    required this.autor,
    required this.titulo,
    this.editora,
    this.revista,
    this.subtituloArtigo,
    this.subtituloRevista,
    this.volume,
    this.fasciculo,
    this.paginaInicial,
    this.paginaFinal,
    this.mes,
    this.doi,
    this.artigoOnline = false,
    this.url,
    this.nomeSite,
    this.acesso,
    this.local,
    this.pagina,
    required this.ano,
  });

  static String formatAuthor(String author) {
    final authors = _formattedAuthors(author);

    if (authors.isEmpty) {
      return '';
    }
    if (authors.length == 1) {
      return authors.first;
    }

    return '${authors.sublist(0, authors.length - 1).join(', ')} e ${authors.last}';
  }

  static String formatArticleAuthors(String author) {
    return formatSeparatedAuthors(author);
  }

  static String formatSeparatedAuthors(String author) {
    return _formattedAuthors(author).join('; ');
  }

  static List<String> _formattedAuthors(String author) {
    return author
        .split(RegExp(r'\s*(?:,|\be\b)\s*', caseSensitive: false))
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .map((name) {
          final parts = name.split(RegExp(r'\s+'));

          if (parts.length == 1) {
            return parts.first.toUpperCase();
          }

          final surname = parts.last.toUpperCase();
          final names = parts.sublist(0, parts.length - 1).join(' ');

          return '$surname, $names';
        })
        .toList();
  }

  String get emphasizedText {
    if (tipo == 'Livro') {
      return titulo;
    }
    if (tipo == 'Site') {
      return titulo;
    }
    if (tipo == 'Artigo') {
      return revista ?? '';
    }
    return '';
  }

  int get emphasizedTextStart {
    if (tipo == 'Livro') {
      final authorText = Citation.formatSeparatedAuthors(autor);
      return authorText.isEmpty ? 0 : authorText.length + 2;
    }
    if (tipo == 'Site') {
      final authorText = Citation.formatAuthor(autor).toUpperCase();
      return authorText.isEmpty ? 0 : authorText.length + 2;
    }
    if (tipo == 'Artigo') {
      final authorText = Citation.formatArticleAuthors(autor);
      final titleText = _joinedTitle(titulo, subtituloArtigo);
      return (authorText.isEmpty ? 0 : authorText.length + 2) +
          titleText.length +
          2;
    }
    return -1;
  }

  String generateReference() {
    final authorText = Citation.formatAuthor(autor);
    final authorPrefix = authorText.isEmpty ? '' : '$authorText. ';
    final locationText = local?.trim() ?? '';
    final pageText = pagina?.trim() ?? '';
    final pageSuffix = pageText.isEmpty ? '' : ', p. $pageText';

    if (tipo == 'Livro') {
      final bookAuthors = Citation.formatSeparatedAuthors(autor);
      final bookAuthorPrefix = bookAuthors.isEmpty ? '' : '$bookAuthors. ';
      final publication = locationText.isEmpty
          ? editora ?? ''
          : '$locationText: ${editora ?? ''}';
      return '$bookAuthorPrefix$titulo. $publication, $ano$pageSuffix.';
    }

    if (tipo == 'Artigo') {
      return _generateArticleReference();
    }

    if (tipo == 'Site') {
      final siteAuthorPrefix = authorText.isEmpty
          ? ''
          : '${authorText.toUpperCase()}. ';
      final siteUrl = _formatSiteUrl(url ?? '');
      return '$siteAuthorPrefix$titulo. ${nomeSite ?? ''}, $ano. '
          'Disponível em: $siteUrl. Acesso em: ${acesso ?? ''}.';
    }

    return '$authorPrefix$titulo.';
  }

  String _formatSiteUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return value.trim();
    }

    final path = uri.path == '/' ? '' : uri.path;
    final query = uri.hasQuery ? '?${uri.query}' : '';
    final fragment = uri.hasFragment ? '#${uri.fragment}' : '';
    return '${uri.host}$path$query$fragment';
  }

  String _generateArticleReference() {
    final authors = Citation.formatArticleAuthors(autor);
    final articleTitle = _joinedTitle(titulo, subtituloArtigo);
    final journalTitle = revista?.trim() ?? '';
    final journalSubtitle = subtituloRevista?.trim() ?? '';
    final journalText = journalSubtitle.isEmpty
        ? journalTitle
        : '$journalTitle: $journalSubtitle';
    final monthText = mes?.trim() ?? '';
    final doiText = doi?.trim() ?? '';
    final urlText = url?.trim() ?? '';
    final accessText = acesso?.trim() ?? '';
    final dateText = monthText.isEmpty ? ano : '$monthText $ano';
    final pageRange = '${paginaInicial ?? ''}-${paginaFinal ?? ''}';

    final parts = [
      '$authors. $articleTitle. $journalText, ${local ?? ''}, '
          'v. ${volume ?? ''}, n. ${fasciculo ?? ''}, p. $pageRange, $dateText.',
    ];
    if (doiText.isNotEmpty) {
      parts.add('DOI: ${_formatSiteUrl(doiText)}.');
    }
    if (artigoOnline) {
      if (urlText.isNotEmpty) {
        parts.add('Disponível em: ${_formatSiteUrl(urlText)}.');
      }
      if (accessText.isNotEmpty) {
        parts.add('Acesso em: $accessText.');
      }
    }

    return parts.join(' ');
  }

  String _joinedTitle(String title, String? subtitle) {
    final subtitleText = subtitle?.trim() ?? '';
    return subtitleText.isEmpty ? title : '$title: $subtitleText';
  }
}
