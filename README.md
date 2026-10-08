# Academic Citation Generator

## Objetivo
Este projeto é um aplicativo Flutter simples para gerar referências acadêmicas de livros, artigos e sites a partir de dados informados manualmente pelo usuário.

## Funcionalidades
- Tela inicial com seleção do tipo de fonte
- Formulário específico para cada tipo de referência
- Validação de campos obrigatórios
- Geração de referência em formato acadêmico simples
- Exibição do resultado em uma tela dedicada
- Navegação básica entre páginas

## Tecnologias utilizadas
- Flutter
- Dart
- Material Design

## Estrutura das pastas
- lib/main.dart: inicialização do app
- lib/models/citation.dart: modelo de dados da citação
- lib/pages/home_page.dart: tela inicial
- lib/pages/citation_form_page.dart: formulário de preenchimento
- lib/pages/result_page.dart: tela de resultado
- lib/widgets/citation_field.dart: campo reutilizável de entrada

## Como executar
1. Acesse a pasta do projeto.
2. Certifique-se de que o Flutter está instalado e configurado.
3. Execute:

```bash
flutter pub get
flutter run
```

## Observação
Os dados são mantidos apenas em memória durante a execução do aplicativo. Não há persistência, banco de dados ou armazenamento externo.
