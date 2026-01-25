import 'dart:io';

// Script de Auditoria de CI para SoloForte
// Objetivo: Impedir AppBar/Scaffold em rotas do ShellRoute (/map)
// Uso: dart scripts/audit_shell_route.dart

void main() async {
  print('\n🛡️  AUDITORIA DE SHELL_ROUTE (NO-APPBAR POLICY) 🛡️\n');

  final rootDir = Directory.current;
  final libDir = Directory('${rootDir.path}/lib');
  final routerFile = File('${libDir.path}/core/router.dart');

  if (!routerFile.existsSync()) {
    print('❌ CRÍTICO: router.dart não encontrado em ${routerFile.path}');
    exit(1);
  }

  // 1. Mapeamento de Widgets do ShellRoute
  print('📍 Identificando widgets dentro do ShellRoute...');
  final routerContent = await routerFile.readAsString();
  final targetWidgets = <String>{};

  // Encontrar o bloco ShellRoute de forma mais flexível
  final shellRouteMatch = RegExp(
    r'ShellRoute\s*\(\s*.*?routes:\s*\[(.*?)\]\s*,\s*\)',
    dotAll: true,
  ).firstMatch(routerContent);
  final finalMatch =
      shellRouteMatch ??
      RegExp(
        r'ShellRoute\s*\(\s*.*?routes:\s*\[(.*?)\]\s*\)',
        dotAll: true,
      ).firstMatch(routerContent);

  if (finalMatch == null) {
    print('❌ CRÍTICO: Bloco ShellRoute não identificado no router.dart');
    exit(1);
  }

  final shellRoutesBlock = finalMatch.group(1) ?? "";

  // Regex expandida para capturar:
  // 1. Arrow functions: => const WidgetName(
  // 2. Block functions: return WidgetName(
  final widgetRegex = RegExp(
    r'(?:=>|return)\s+(?:const\s+)?([A-Z]\w+)\(',
    multiLine: true,
  );
  final matches = widgetRegex.allMatches(shellRoutesBlock);

  for (final match in matches) {
    final widgetName = match.group(1);
    if (widgetName != null &&
        widgetName != 'DashboardLayout' &&
        widgetName != 'LatLng') {
      targetWidgets.add(widgetName);
    }
  }

  if (targetWidgets.isEmpty) {
    print('⚠️  AVISO: Nenhum widget identificado dentro do ShellRoute.');
  } else {
    print(
      '   ✅ Blocos protegidos (${targetWidgets.length}): ${targetWidgets.join(", ")}',
    );
  }

  // 2. Análise dos Arquivos Fonte
  print('\n🔍 Iniciando varredura técnica...');

  final sourceFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  int totalErrors = 0;
  List<String> errorReports = [];

  for (final file in sourceFiles) {
    if (file.path.endsWith('dashboard_layout.dart')) continue;
    if (file.path.endsWith('.g.dart') || file.path.endsWith('.freezed.dart')) {
      continue;
    }

    final content = await file.readAsString();

    String? matchedWidget;
    for (final widget in targetWidgets) {
      if (content.contains(RegExp('class\\s+$widget\\b'))) {
        matchedWidget = widget;
        break;
      }
    }

    if (matchedWidget != null) {
      final fileLines = content.split('\n');

      for (int i = 0; i < fileLines.length; i++) {
        final line = fileLines[i];
        final lineNumber = i + 1;

        // Verificar bypass: linha anterior OU linha atual
        final previousLine = i > 0 ? fileLines[i - 1] : '';
        if (line.contains('ci: allow-appbar') ||
            previousLine.contains('ci: allow-appbar')) {
          continue;
        }

        final trimmedLine = line.trim();
        if (trimmedLine.startsWith('//') || trimmedLine.startsWith('import')) {
          continue;
        }

        if (trimmedLine.contains('Scaffold(') ||
            (trimmedLine.contains('AppBar(') &&
                !trimmedLine.contains('SliverAppBar')) ||
            trimmedLine.contains('appBar:')) {
          final violationType = trimmedLine.contains('Scaffold')
              ? 'Scaffold'
              : 'AppBar';

          errorReports.add(
            '   ❌ ${file.path.split('/').last}:$lineNumber ($violationType em $matchedWidget)\n'
            '      Linhagem: "$trimmedLine"',
          );
          totalErrors++;
        }
      }
    }
  }

  // 3. Veredito Final
  if (totalErrors > 0) {
    print(
      '\n🔴 FALHA DE CI: Foram encontradas $totalErrors violações da Regra do ShellRoute.',
    );
    print('---------------------------------------------------');
    for (var report in errorReports) {
      print(report);
    }
    print('---------------------------------------------------');
    print('\n🛡️  PLANILHA DE CORREÇÃO:');
    print('   1. Rota herda DashboardLayout? Remova Scaffold/AppBar.');
    print('   2. É um Modal/Overlay legítimo? Adicione: // ci: allow-appbar');
    exit(1);
  } else {
    print('\n✅ SUCESSO: Todas as telas do ShellRoute estão em conformidade.');
    exit(0);
  }
}
