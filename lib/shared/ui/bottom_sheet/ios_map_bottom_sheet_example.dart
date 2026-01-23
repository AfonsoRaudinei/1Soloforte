import 'package:flutter/material.dart';
import 'package:soloforte_app/shared/ui/bottom_sheet/ios_map_bottom_sheet.dart';
import 'package:soloforte_app/shared/ui/bottom_sheet/ios_map_bottom_sheet_button.dart';

/// Exemplo de uso do IosMapBottomSheet
///
/// Este arquivo demonstra como usar o botão e o bottom sheet
/// no contexto de um mapa (ou qualquer outra tela).
///
/// IMPORTANTE: Este é apenas um exemplo de demonstração.
/// Não use este arquivo diretamente no app.
class IosMapBottomSheetExample extends StatelessWidget {
  const IosMapBottomSheetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mapa (ou qualquer conteúdo de fundo)
          Container(
            color: Colors.grey[200],
            child: const Center(
              child: Text(
                'MAPA\n(visível ao fundo)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),

          // Botão para abrir o Bottom Sheet
          Positioned(
            bottom: 40,
            left: 20,
            child: IosMapBottomSheetButton(
              icon: Icons.info_outline,
              label: 'Ver Publicação',
              onTap: () => _showBottomSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    IosMapBottomSheet.show(
      context: context,
      child: const IosMapBottomSheetContent(
        title: 'Título da Publicação',
        subtitle: 'Subtítulo ou informação secundária',
        description:
            'Este é um exemplo de conteúdo genérico dentro do Bottom Sheet. '
            'Você pode substituir este conteúdo por qualquer widget personalizado. '
            'O Bottom Sheet suporta scroll, drag para expandir/recolher e pode ser '
            'fechado arrastando para baixo.',
        customContent: Placeholder(fallbackHeight: 200, color: Colors.grey),
      ),
    );
  }
}

/// Exemplo 2: Uso com conteúdo personalizado
void showCustomBottomSheet(BuildContext context) {
  IosMapBottomSheet.show(
    context: context,
    initialHeightFactor: 0.3,
    maxHeightFactor: 0.85,
    child: Column(
      children: [
        // Seu conteúdo personalizado aqui
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Conteúdo Customizado',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                height: 100,
                color: Colors.blue[100],
                child: const Center(child: Text('Widget Personalizado')),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
