import 'package:citacoes_app/models/citation.dart';
import 'package:citacoes_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final Citation citation;

  const ResultPage({super.key, required this.citation});

  Widget _buildReferenceText() {
    final reference = citation.generateReference();
    const style = TextStyle(fontSize: 18, height: 1.5);

    final emphasizedText = citation.emphasizedText;
    final titleStart = citation.emphasizedTextStart;
    final titleEnd = titleStart + emphasizedText.length;
    if (titleStart < 0 ||
        emphasizedText.isEmpty ||
        titleEnd > reference.length) {
      return Text(reference, style: style);
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: reference.substring(0, titleStart)),
          TextSpan(
            text: emphasizedText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: reference.substring(titleEnd)),
        ],
      ),
      style: style,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Referência gerada',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: _buildReferenceText(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text(
                  'NOVA CITAÇÃO',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                child: const Text(
                  'VOLTAR',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
