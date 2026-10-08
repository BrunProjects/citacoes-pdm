import 'package:citacoes_app/models/citation.dart';
import 'package:citacoes_app/pages/citation_form_page.dart';
import 'package:citacoes_app/pages/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Citation author formatting', () {
    test('formats multiple authors separated by commas and e', () {
      final citation = Citation(
        tipo: 'Livro',
        autor: 'João Silva, Maria Souza e Ana Lima',
        titulo: 'Título',
        editora: 'Editora',
        ano: '2024',
      );

      expect(
        citation.generateReference(),
        'SILVA, João; SOUZA, Maria; LIMA, Ana. Título. Editora, 2024.',
      );
    });

    test('formats a book reference with the required publication city', () {
      final citation = Citation(
        tipo: 'Livro',
        autor: 'Ricardo Silva',
        titulo: 'Introdução à Ciência de Dados',
        local: 'São Paulo',
        editora: 'Editora Tecno',
        ano: '2024',
      );

      expect(
        citation.generateReference(),
        'SILVA, Ricardo. Introdução à Ciência de Dados. '
        'São Paulo: Editora Tecno, 2024.',
      );
      expect(citation.emphasizedText, 'Introdução à Ciência de Dados');
    });

    test('formats a two-author book with semicolon separation', () {
      final citation = Citation(
        tipo: 'Livro',
        autor: 'Lucas Almeida e Mariana Costa',
        titulo: 'Metodologia da Pesquisa Científica',
        local: 'Brasília',
        editora: 'Aliança Editora',
        ano: '2025',
      );

      expect(
        citation.generateReference(),
        'ALMEIDA, Lucas; COSTA, Mariana. '
        'Metodologia da Pesquisa Científica. '
        'Brasília: Aliança Editora, 2025.',
      );
    });

    test('includes the optional location and page for a book', () {
      final citation = Citation(
        tipo: 'Livro',
        autor: 'João Silva',
        titulo: 'Título',
        editora: 'Editora',
        local: 'São Paulo',
        pagina: '25',
        ano: '2024',
      );

      expect(
        citation.generateReference(),
        'SILVA, João. Título. São Paulo: Editora, 2024, p. 25.',
      );
    });

    test('rejects author input containing only separators', () {
      expect(Citation.formatAuthor(' , e  '), isEmpty);
    });

    test('formats a site reference with site name, URL, and access date', () {
      final citation = Citation(
        tipo: 'Site',
        autor: 'G1',
        titulo: 'Cientistas descobrem nova espécie de dinossauro no Brasil',
        nomeSite: 'Portal G1',
        ano: '2024',
        url: 'https://globo.com/',
        acesso: '8 out. 2026',
      );

      expect(
        citation.generateReference(),
        'G1. Cientistas descobrem nova espécie de dinossauro no Brasil. '
        'Portal G1, 2024. Disponível em: globo.com. '
        'Acesso em: 8 out. 2026.',
      );
    });

    test('formats an online journal article with required fields', () {
      final citation = Citation(
        tipo: 'Artigo',
        autor: 'Ricardo Silva',
        titulo: 'Inteligência artificial na educação',
        revista: 'Revista de Tecnologia',
        local: 'São Paulo',
        volume: '10',
        fasciculo: '2',
        paginaInicial: '15',
        paginaFinal: '30',
        ano: '2024',
        artigoOnline: true,
        url: 'https://revistatec.com/',
        acesso: '8 out. 2026',
      );

      expect(
        citation.generateReference(),
        'SILVA, Ricardo. Inteligência artificial na educação. '
        'Revista de Tecnologia, São Paulo, v. 10, n. 2, p. 15-30, 2024. '
        'Disponível em: revistatec.com. Acesso em: 8 out. 2026.',
      );
    });

    test('separates article authors with semicolons', () {
      final citation = Citation(
        tipo: 'Artigo',
        autor: 'Lucas Almeida e Mariana Costa',
        titulo: 'Impactos da reforma tributária no comércio brasileiro',
        revista: 'Cadernos de Economia',
        local: 'Brasília',
        volume: '32',
        fasciculo: '4',
        paginaInicial: '112',
        paginaFinal: '128',
        ano: '2025',
        artigoOnline: true,
        url: 'https://cadernosecon.org',
        acesso: '8 out. 2026',
      );

      expect(
        citation.generateReference(),
        'ALMEIDA, Lucas; COSTA, Mariana. '
        'Impactos da reforma tributária no comércio brasileiro. '
        'Cadernos de Economia, Brasília, v. 32, n. 4, p. 112-128, 2025. '
        'Disponível em: cadernosecon.org. Acesso em: 8 out. 2026.',
      );
    });

    test(
      'includes optional article subtitle, journal subtitle, month, and DOI',
      () {
        final citation = Citation(
          tipo: 'Artigo',
          autor: 'Ana Martins',
          titulo: 'O futuro da saúde pública',
          subtituloArtigo: 'desafios pós-pandemia',
          revista: 'Revista Brasileira de Medicina',
          subtituloRevista: 'Estudos Clínicos',
          local: 'Rio de Janeiro',
          volume: '45',
          fasciculo: '1',
          paginaInicial: '45',
          paginaFinal: '60',
          mes: 'mar.',
          ano: '2026',
          doi: 'https://doi.org',
          artigoOnline: true,
          url: 'https://rbmedicina.com.br',
          acesso: '8 out. 2026',
        );

        expect(
          citation.generateReference(),
          'MARTINS, Ana. O futuro da saúde pública: desafios pós-pandemia. '
          'Revista Brasileira de Medicina: Estudos Clínicos, Rio de Janeiro, '
          'v. 45, n. 1, p. 45-60, mar. 2026. DOI: doi.org. '
          'Disponível em: rbmedicina.com.br. Acesso em: 8 out. 2026.',
        );
      },
    );
  });

  testWidgets('requires an author in the book form', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CitationFormPage(tipo: 'Livro')),
    );

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(2), 'São Paulo');
    await tester.enterText(fields.at(1), 'Título');
    await tester.enterText(fields.at(3), 'Editora');
    await tester.enterText(fields.at(4), '2024');
    final generateButton = find.text('GERAR REFERÊNCIA');
    await tester.ensureVisible(generateButton);
    await tester.pumpAndSettle();
    await tester.tap(generateButton);
    await tester.pump();

    expect(
      find.text('Preencha todos os campos obrigatórios.'),
      findsAtLeastNWidgets(1),
    );
  });

  testWidgets('requires a publication city in the book form', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CitationFormPage(tipo: 'Livro')),
    );

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Ricardo Silva');
    await tester.enterText(fields.at(1), 'Título');
    await tester.enterText(fields.at(3), 'Editora');
    await tester.enterText(fields.at(4), '2024');
    final generateButton = find.text('GERAR REFERÊNCIA');
    await tester.ensureVisible(generateButton);
    await tester.pumpAndSettle();
    await tester.tap(generateButton);
    await tester.pump();

    expect(
      find.text('Preencha todos os campos obrigatórios.'),
      findsAtLeastNWidgets(1),
    );
  });

  testWidgets('renders the book title in bold', (tester) async {
    const title = 'Introdução à Ciência de Dados';
    final citation = Citation(
      tipo: 'Livro',
      autor: 'Ricardo Silva',
      titulo: title,
      local: 'São Paulo',
      editora: 'Editora Tecno',
      ano: '2024',
    );

    await tester.pumpWidget(MaterialApp(home: ResultPage(citation: citation)));

    final referenceText = tester.widgetList<Text>(find.byType(Text)).firstWhere(
      (text) {
        final span = text.textSpan;
        return span is TextSpan &&
            (span.children?.whereType<TextSpan>().any(
                  (child) =>
                      child.text == title &&
                      child.style?.fontWeight == FontWeight.bold,
                ) ??
                false);
      },
    );

    expect(referenceText.textSpan, isNotNull);
  });

  testWidgets('groups article fields and shows online access by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: CitationFormPage(tipo: 'Artigo')),
    );

    expect(find.text('Campos obrigatórios'), findsOneWidget);
    expect(find.text('Campos opcionais'), findsOneWidget);
    expect(find.text('Volume'), findsOneWidget);
    expect(find.text('Fascículo (número)'), findsOneWidget);
    expect(find.text('Página inicial'), findsOneWidget);
    expect(find.text('Página final'), findsOneWidget);
    expect(find.text('URL ou endereço eletrônico'), findsOneWidget);
    expect(find.text('Acesso em'), findsOneWidget);
  });

  testWidgets('renders the article journal title in bold', (tester) async {
    final citation = Citation(
      tipo: 'Artigo',
      autor: 'Ricardo Silva',
      titulo: 'Inteligência artificial na educação',
      revista: 'Revista de Tecnologia',
      local: 'São Paulo',
      volume: '10',
      fasciculo: '2',
      paginaInicial: '15',
      paginaFinal: '30',
      ano: '2024',
    );

    await tester.pumpWidget(MaterialApp(home: ResultPage(citation: citation)));

    final referenceText = tester.widgetList<Text>(find.byType(Text)).firstWhere(
      (text) {
        final span = text.textSpan;
        return span is TextSpan &&
            (span.children?.whereType<TextSpan>().any(
                  (child) =>
                      child.text == 'Revista de Tecnologia' &&
                      child.style?.fontWeight == FontWeight.bold,
                ) ??
                false);
      },
    );

    expect(referenceText.textSpan, isNotNull);
  });
}
