import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/features/marketing/presentation/providers/marketing_selection_provider.dart';

class CasesDashboard extends ConsumerWidget {
  const CasesDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: Color(0xFF1D1D1F),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24.0,
                          horizontal: 16.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'O que você deseja criar?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ListTile(
                              leading: const Icon(
                                Icons.star_outline,
                                color: Color(0xFF4ADE80),
                                size: 30,
                              ),
                              title: const Text('Novo Case de Sucesso'),
                              subtitle: const Text(
                                'Mostre resultados incríveis',
                              ),
                              onTap: () {
                                Navigator.pop(context); // Close sheet
                                ref
                                    .read(marketingSelectionProvider.notifier)
                                    .state = const MarketingSelectionState(
                                  isSelecting: true,
                                  reportType: 'case',
                                );
                                context.go('/map');
                              },
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(
                                Icons.compare_arrows,
                                color: Colors.blue,
                                size: 30,
                              ),
                              title: const Text('Avaliação Lado a Lado'),
                              subtitle: const Text(
                                'Comparativo A vs B em campo',
                              ),
                              onTap: () {
                                Navigator.pop(context); // Close sheet
                                ref
                                    .read(marketingSelectionProvider.notifier)
                                    .state = const MarketingSelectionState(
                                  isSelecting: true,
                                  reportType: 'side_by_side',
                                );
                                context.go('/map');
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Novo Case'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ADE80),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Stats Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return GridView.count(
                crossAxisCount: isWide ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: isWide ? 1.5 : 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  _StatCard(
                    label: 'Total de Cases',
                    value: '3',
                    change: '✨ 1 novo este mês',
                  ),
                  _StatCard(
                    label: 'Visualizações',
                    value: '4.1K',
                    change: '📈 +28% vs mês anterior',
                  ),
                  _StatCard(
                    label: 'Economia Gerada',
                    value: 'R\$ 62.5K',
                    change: '💰 Soma total',
                  ),
                  _StatCard(
                    label: 'Produtividade Média',
                    value: '+38%',
                    change: '🌾 Ganho médio',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),

          // Cases Section
          const Text(
            'Cases Recentes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 16),
          _buildCasesGrid(),
        ],
      ),
    );
  }

  Widget _buildCasesGrid() {
    // Mock Data
    final cases = [
      {
        'producer': 'Fazenda Santa Rita',
        'location': 'Jataizinho - PR',
        'productivity': '80 sc/ha',
        'gain': '+38% de ganho',
        'savings': 'R\$ 22.000',
        'views': '1.234',
        'shares': '89',
        'size': 'premium',
      },
      {
        'producer': 'Fazenda Vista Verde',
        'location': 'Castro - PR',
        'productivity': '125 sc/ha',
        'gain': '+42% de ganho',
        'savings': 'R\$ 28.000',
        'views': '2.100',
        'shares': '124',
        'size': 'medio',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        mainAxisExtent: 340,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: cases.length,
      itemBuilder: (context, index) {
        final c = cases[index];
        return _CaseCard(data: c);
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String change;

  const _StatCard({
    required this.label,
    required this.value,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A2F),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            change,
            style: const TextStyle(fontSize: 12, color: Color(0xFF22C55E)),
          ),
        ],
      ),
    );
  }
}

class _CaseCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _CaseCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final size = data['size'] as String;
    Color badgeParams = const Color(0xFFCD7F32);
    Color badgeText = const Color(0xFF7A4A1A);
    String badgeLabel = 'Básico';

    if (size == 'premium') {
      badgeParams = const Color(0xFFD4AF37);
      badgeText = const Color(0xFF8B6914);
      badgeLabel = 'Premium';
    } else if (size == 'medio') {
      badgeParams = const Color(0xFFA8A9AD);
      badgeText = const Color(0xFF5A5A5A);
      badgeLabel = 'Médio';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Area
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    color: Color(0xFF4ADE80),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 48,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: badgeParams,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badgeLabel,
                      style: TextStyle(
                        color: badgeText,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['producer'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1D1F),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Color(0xFF22C55E),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data['location'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3A2F), Color(0xFF0F2417)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              data['productivity'],
                              style: const TextStyle(
                                fontSize: 20,
                                /* Reduced slightly to fit grid */
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4ADE80),
                              ),
                            ),
                            const Text(
                              'PRODUTIVIDADE',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: Colors.white60,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${data['gain']} | ${data['savings']}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF4ADE80),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _IconStat(Icons.visibility_outlined, data['views']),
                      const SizedBox(width: 14),
                      _IconStat(Icons.share_outlined, data['shares']),
                      const Spacer(),
                      _ActionButton('edit'),
                      const SizedBox(width: 4),
                      _ActionButton('delete'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconStat extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconStat(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6B7280)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  const _ActionButton(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A2F),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
