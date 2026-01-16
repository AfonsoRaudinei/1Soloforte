import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

class SystemDocumentationScreen extends StatefulWidget {
  const SystemDocumentationScreen({super.key});

  @override
  State<SystemDocumentationScreen> createState() =>
      _SystemDocumentationScreenState();
}

class _SystemDocumentationScreenState extends State<SystemDocumentationScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _sections = [
    {
      'title': '1. Visão Geral',
      'icon': Icons.insights_outlined,
      'content': _VisaoGeralSection(),
    },
    {
      'title': '2. Arquitetura',
      'icon': Icons.account_tree_outlined,
      'content': _ArquiteturaSection(),
    },
    {
      'title': '3. Navegação (Rotas)',
      'icon': Icons.map_outlined,
      'content': _RotasSection(),
    },
    {
      'title': '4. Contrato Técnico',
      'icon': Icons.handshake_outlined,
      'content': _ContratoSection(),
    },
    {
      'title': '5. Mapa do Código',
      'icon': Icons.folder_open_outlined,
      'content': _CodigoSection(),
    },
    {
      'title': '6. Dados e Persistência',
      'icon': Icons.storage_outlined,
      'content': _DadosSection(),
    },
    {
      'title': '7. Regras e Antipadrões',
      'icon': Icons.rule_outlined,
      'content': _RegrasSection(),
    },
    {
      'title': '8. Status de Implementação',
      'icon': Icons.checklist_rtl_outlined,
      'content': _StatusSection(),
    },
    {
      'title': '9. Histórico de Decisões',
      'icon': Icons.history_edu_outlined,
      'content': _HistoricoSection(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Documentação do Sistema'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Row(
        children: [
          // Index Menu (Side)
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.grey.shade200)),
            ),
            child: ListView.builder(
              itemCount: _sections.length,
              itemBuilder: (context, index) {
                final section = _sections[index];
                final isSelected = _selectedIndex == index;
                return ListTile(
                  leading: Icon(
                    section['icon'],
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade600,
                  ),
                  title: Text(
                    section['title'],
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  onTap: () => setState(() => _selectedIndex = index),
                  selected: isSelected,
                  selectedTileColor: AppColors.primary.withValues(alpha: 0.05),
                );
              },
            ),
          ),
          // Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _sections[_selectedIndex]['title'],
                    style: AppTypography.h1.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 24),
                  _sections[_selectedIndex]['content'] as Widget,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Section Widgets ---

class _VisaoGeralSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'O SoloForte é uma plataforma integrada para gestão agrícola e consultoria técnica em campo. '
          'Seu objetivo é centralizar informações de produtores, propriedades e safras, permitindo um '
          'acompanhamento técnico preciso e georreferenciado.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 24),
        _buildInfoCard(
          'Princípio Central: Cliente como Raiz',
          'Toda a estrutura de dados orbita em torno do Cliente (Produtor). Uma ação sem vínculo '
              'a um clientId é considerada inconsistente dentro da arquitetura SoloForte.',
          Icons.person_pin_circle_outlined,
        ),
      ],
    );
  }
}

class _ArquiteturaSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'O sistema é construído sobre o framework Flutter, garantindo alto desempenho e '
          'uma interface fluida em múltiplas plataformas.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 20),
        _buildBulletPoint('Plataforma Principal', 'Flutter (Dart)'),
        _buildBulletPoint(
          'Gerenciamento de Estado',
          'Riverpod (Provider Pattern)',
        ),
        _buildBulletPoint(
          'Navegação',
          'GoRouter (Baseado em URLs declarativas)',
        ),
        _buildBulletPoint(
          'Organização',
          'Modular por Features (Domain-Driven Design simplificado)',
        ),
      ],
    );
  }
}

class _RotasSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mapeamento das rotas principais registradas no sistema:',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 16),
        _buildRouteTable([
          ['/map', 'Tela Principal Operational (Dashboard Geográfico)'],
          ['/map/clients', 'Listagem e Gestão de Produtores'],
          ['/map/calendar', 'Agenda Técnica e Planejamento'],
          ['/map/occurrences', 'Histórico de Ocorrências em Campo'],
          ['/map/marketing', 'Módulo de Publicação e Cases'],
          ['/map/settings', 'Configurações de Perfil e Sistema'],
          ['/reports', 'Central de Relatórios Administrativos'],
        ]),
      ],
    );
  }
}

class _ContratoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Para garantir a integridade da integração entre módulos, os seguintes contratos devem ser respeitados:',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 20),
        _buildContractItem(
          'Cliente ↔ Agenda',
          'O evento de agenda DEVE conter o clientId para permitir o Check-in.',
        ),
        _buildContractItem(
          'Cliente ↔ Mapa',
          'A visualização de talhões (polígonos) é filtrada pelo clientId selecionado.',
        ),
        _buildContractItem(
          'Cliente ↔ Ocorrências',
          'O registro de anomalias sempre associa a coordenada ao cliente da área corrente.',
        ),
        const SizedBox(height: 24),
        _buildWarningCard(
          'Regra de Ouro: Nunca usar Strings como chave primária de vínculo entre módulos. Use sempre o ID hexadecimal único.',
        ),
      ],
    );
  }
}

class _CodigoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descrição das responsabilidades por diretório:',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 20),
        _buildFolderItem(
          'lib/features/clients',
          'Modelos, telas e repositórios de Clientes e Fazendas.',
        ),
        _buildFolderItem(
          'lib/features/agenda',
          'Lógica de eventos, calendário e visitas técnicas.',
        ),
        _buildFolderItem(
          'lib/features/map',
          'Motores de renderização cartográfica e ferramentas de desenho.',
        ),
        _buildFolderItem(
          'lib/features/occurrences',
          'Fluxo de captura de fotos e dados técnicos de campo.',
        ),
        _buildFolderItem(
          'lib/core/router.dart',
          'Definição única da árvore de rotas e guardas de acesso.',
        ),
        _buildFolderItem(
          'lib/core/database',
          'Configurações de persistência e migrations.',
        ),
      ],
    );
  }
}

class _DadosSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'O SoloForte utiliza uma estratégia híbrida de dados:',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 20),
        _buildBulletPoint(
          'Persistência Local',
          'SQLite (SQFlite) para funcionamento offline.',
        ),
        _buildBulletPoint(
          'Sincronização Cloud',
          'Firebase (Auth) e Supabase (Base de Dados em Nuvem).',
        ),
        _buildBulletPoint(
          'Contexto Volátil',
          'Camadas de mapa (Tiles) são carregadas via cache de rede.',
        ),
      ],
    );
  }
}

class _RegrasSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Regras Técnicas Obrigatórias:', style: AppTypography.h4),
        const SizedBox(height: 12),
        _buildBulletPoint(
          'Vínculo',
          'Sempre utilizar clientId para qualquer dado gerado.',
        ),
        _buildBulletPoint(
          'Coordenadas',
          'Ocorrências devem sempre possuir Lat/Long capturados no momento.',
        ),
        const SizedBox(height: 32),
        Text('Antipadrões Proibidos:', style: AppTypography.h4),
        const SizedBox(height: 12),
        _buildBulletPoint(
          'Filtros',
          'Não realizar filtros por String (Nome) quando houver ID disponível.',
        ),
        _buildBulletPoint(
          'Contexto',
          'Não injetar BuildContext em serviços fora da camada Presentation.',
        ),
      ],
    );
  }
}

class _StatusSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Status atual da implementação (Consolidado):'),
        const SizedBox(height: 16),
        _buildStatusTable([
          ['Clientes', '✅ Estável', 'CRUD completo fundamentado'],
          ['Agenda', '✅ Estável', 'Visão semanal e detalhamento ok'],
          ['Mapa', '⚠️ Em Evolução', 'Suporte a NDVI em refinamento'],
          ['Ocorrências', '✅ Estável', 'Fluxo de campo robusto'],
          ['Relatórios', '⚠️ Em Refinamento', 'Geração de PDF funcional'],
        ]),
      ],
    );
  }
}

class _HistoricoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHistoryItem(
          'Jan 2026',
          'Migração de navegação imperativa para GoRouter (Declarativa).',
        ),
        _buildHistoryItem(
          'Jan 2026',
          'Decisão de centralizar o Dashboard Operacional no módulo de Mapas.',
        ),
        _buildHistoryItem(
          'Jan 2026',
          'Implementação de persistência offline resiliente.',
        ),
      ],
    );
  }
}

// --- Helper UI Components ---

Widget _buildInfoCard(String title, String text, IconData icon) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.blue.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(text, style: const TextStyle(height: 1.4)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildBulletPoint(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
        const SizedBox(width: 12),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    ),
  );
}

Widget _buildRouteTable(List<List<String>> data) {
  return Table(
    border: TableBorder.all(color: Colors.grey.shade300),
    columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
    children: data.map((row) {
      return TableRow(
        children: row
            .map(
              (cell) => Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  cell,
                  style: TextStyle(
                    fontFamily: row.indexOf(cell) == 0 ? 'monospace' : null,
                    fontWeight: row.indexOf(cell) == 0 ? FontWeight.bold : null,
                  ),
                ),
              ),
            )
            .toList(),
      );
    }).toList(),
  );
}

Widget _buildStatusTable(List<List<String>> data) {
  return Table(
    border: TableBorder.all(color: Colors.grey.shade300),
    children: data.map((row) {
      return TableRow(
        children: row
            .map(
              (cell) =>
                  Padding(padding: const EdgeInsets.all(12), child: Text(cell)),
            )
            .toList(),
      );
    }).toList(),
  );
}

Widget _buildContractItem(String title, String description) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(description, style: const TextStyle(color: Colors.black54)),
      ],
    ),
  );
}

Widget _buildWarningCard(String text) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.amber.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
    ),
    child: Row(
      children: [
        const Icon(Icons.warning_amber_rounded, color: Colors.amber),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}

Widget _buildFolderItem(String path, String description) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Icon(Icons.folder, color: Colors.amber.shade700, size: 20),
        const SizedBox(width: 8),
        Text(
          path,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '- $description',
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ],
    ),
  );
}

Widget _buildHistoryItem(String date, String description) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            date,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: Text(description)),
      ],
    ),
  );
}
