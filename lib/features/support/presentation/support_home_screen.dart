import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/support/data/ticket_repository.dart';
import 'package:soloforte_app/features/support/domain/ticket_model.dart';
import 'package:soloforte_app/features/support/presentation/help_center_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class SupportHomeScreen extends StatefulWidget {
  const SupportHomeScreen({super.key});

  @override
  State<SupportHomeScreen> createState() => _SupportHomeScreenState();
}

class _SupportHomeScreenState extends State<SupportHomeScreen> {
  final _repo = TicketRepository();
  List<Ticket> _tickets = [];
  bool _isLoading = true;
  String _filter = 'Abertas'; // 'Abertas', 'Resolvidas'
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    final tickets = await _repo.loadTickets();
    if (mounted) {
      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    }
  }

  List<Ticket> get _filteredTickets {
    final search = _searchController.text.toLowerCase();
    return _tickets.where((t) {
      final matchSearch =
          t.subject.toLowerCase().contains(search) ||
          t.description.toLowerCase().contains(search);
      bool matchStatus;
      if (_filter == 'Abertas') {
        matchStatus =
            t.status == TicketStatus.open ||
            t.status == TicketStatus.inProgress;
      } else {
        matchStatus =
            t.status == TicketStatus.resolved ||
            t.status == TicketStatus.closed;
      }
      return matchSearch && matchStatus;
    }).toList();
  }

  List<Ticket> get _resolvedRecently {
    return _tickets
        .where(
          (t) =>
              t.status == TicketStatus.resolved ||
              t.status == TicketStatus.closed,
        )
        .toList()
      ..sort(
        (a, b) => b.lastUpdate.compareTo(a.lastUpdate),
      ); // Most recent first
  }

  @override
  Widget build(BuildContext context) {
    final openCount = _tickets
        .where(
          (t) =>
              t.status == TicketStatus.open ||
              t.status == TicketStatus.inProgress,
        )
        .length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Suporte'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTickets,
        child: Column(
          children: [
            // Search
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Buscar conversas...',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip(
                    'Abertas ($openCount)',
                    _filter == 'Abertas',
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip('Resolvidas', _filter == 'Resolvidas'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Main List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (_filteredTickets.isEmpty && !_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: Text('Nenhuma conversa encontrada')),
                    ),

                  ..._filteredTickets.map((t) => _buildConversationCard(t)),

                  if (_filter == 'Abertas' && _resolvedRecently.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Resolvidas Recentemente',
                      style: AppTypography.h4.copyWith(color: Colors.grey),
                    ),
                    const Divider(),
                    ..._resolvedRecently
                        .take(3)
                        .map((t) => _buildResolvedCard(t)),
                  ],
                ],
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await context.push('/dashboard/support/create');
                    _loadTickets();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nova Conversa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (label.startsWith('Abertas')) {
            _filter = 'Abertas';
          } else {
            _filter = 'Resolvidas';
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildConversationCard(Ticket ticket) {
    final isBot =
        ticket.subject.toLowerCase().contains('bot') ||
        ticket.subject.contains('Suporte'); // Mock logic
    final isOpen =
        ticket.status == TicketStatus.open ||
        ticket.status == TicketStatus.inProgress;

    return GestureDetector(
      onTap: () => context.push('/dashboard/support/chat', extra: ticket),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: isBot ? Colors.blue[50] : Colors.grey[100],
              child: Text(isBot ? '🤖' : '👤'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ticket.subject, style: AppTypography.h4),
                  const Divider(height: 12),
                  Text(
                    ticket.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: isOpen ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isOpen ? 'Em aberto' : 'Resolvido',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeago.format(ticket.lastUpdate, locale: 'en_short'),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResolvedCard(Ticket ticket) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.green),
      title: Text(
        ticket.subject,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Resolvido • ${timeago.format(ticket.lastUpdate)}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/dashboard/support/chat', extra: ticket),
    );
  }
}
