import 'package:flutter/material.dart';
import 'package:soloforte_app/features/marketing/data/marketing_publication_repository.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_publication.dart';

/// Script para adicionar publicação de teste
/// Execute via Dev Tools ou adicione ao main temporariamente
Future<void> seedMarketingPublication() async {
  final repository = MarketingPublicationRepository();

  // Criar publicação de teste
  final testPublication =
      MarketingPublication.create(
        latitude: -23.5505,
        longitude: -46.6333,
        type: PublicationType.caseSucesso,
      ).copyWith(
        title: 'Case de Sucesso - Fazenda São João',
        clientName: 'João Silva',
        areaName: 'Talhão Norte',
        description: 'Aumento significativo de produtividade com novo manejo',
        product: 'Fertilizante XYZ',
        campaign: 'Safra 2025/2026',
        harvest: '2026',
        sellerName: 'Maria Santos',
        sellerPhone: '(11) 98765-4321',
        companyName: 'AgroTech Solutions',
        highlightMetric: 'Produtividade',
        highlightValue: 85.5,
        highlightUnit: 'sc/ha',
        status: 'published',
        publishedAt: DateTime.now().subtract(const Duration(days: 7)),
        isVisible: true,
        photos: [
          PublicationPhoto.create(
            path: 'https://picsum.photos/400/300?random=1',
            caption: 'Plantação após aplicação',
            isCover: true,
          ),
        ],
        comparisons: [
          ComparisonEntry.create(
            label: 'Antes',
            order: 0,
          ).copyWith(productivity: 60.0, ndvi: 0.65),
          ComparisonEntry.create(
            label: 'Depois',
            order: 1,
          ).copyWith(productivity: 85.5, ndvi: 0.82),
        ],
      );

  // Salvar no banco
  await repository.save(testPublication);

  print('✅ Publicação de teste criada com sucesso!');
  print('ID: ${testPublication.id}');
  print('Título: ${testPublication.title}');
}

/// Widget de teste para adicionar à árvore
class SeedButton extends StatelessWidget {
  const SeedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await seedMarketingPublication();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicação de teste criada!')),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
