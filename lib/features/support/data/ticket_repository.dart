import 'dart:convert';
import 'package:soloforte_app/core/database/database_helper.dart'; // Import DatabaseHelper
import 'package:soloforte_app/features/support/domain/ticket_model.dart';
import 'package:uuid/uuid.dart';

class TicketRepository {
  // static const String _storageKey = 'soloforte_tickets'; // Removido
  final _uuid = const Uuid();

  Future<List<Ticket>> loadTickets() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      DatabaseHelper.tableTickets,
      orderBy: 'created_at DESC',
    );

    if (result.isEmpty) {
      final mocks = _generateMockTickets();
      // Salvar mocks no banco para persistência inicial
      for (var t in mocks) {
        await _insertTicket(t);
      }
      return mocks;
    }

    return result.map((row) {
      final jsonString = row['json_data'] as String;
      return Ticket.fromJson(jsonDecode(jsonString));
    }).toList();
  }

  Future<Ticket> createTicket({
    required String subject,
    required String description,
    required TicketCategory category,
    required TicketPriority priority,
  }) async {
    final newTicket = Ticket(
      id: _uuid.v4(),
      subject: subject,
      description: description,
      category: category,
      priority: priority,
      status: TicketStatus.open,
      createdAt: DateTime.now(),
      lastUpdate: DateTime.now(),
    );

    await _insertTicket(newTicket);
    return newTicket;
  }

  Future<void> updateTicketStatus(String id, TicketStatus status) async {
    final db = await DatabaseHelper.instance.database;

    // Buscar ticket atual
    final maps = await db.query(
      DatabaseHelper.tableTickets,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final currentJson = maps.first['json_data'] as String;
      final currentTicket = Ticket.fromJson(jsonDecode(currentJson));

      final updatedTicket = currentTicket.copyWith(
        status: status,
        lastUpdate: DateTime.now(),
      );

      await db.update(
        DatabaseHelper.tableTickets,
        {
          'status': status.name,
          'json_data': jsonEncode(updatedTicket.toJson()),
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<void> _insertTicket(Ticket ticket) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(DatabaseHelper.tableTickets, {
      'id': ticket.id,
      'status': ticket.status.name,
      'created_at': ticket.createdAt.millisecondsSinceEpoch,
      'json_data': jsonEncode(ticket.toJson()),
    });
  }

  List<Ticket> _generateMockTickets() {
    return [
      Ticket(
        id: '1234',
        subject: 'Erro na sincronização',
        description: 'Não consigo enviar os dados da visita.',
        category: TicketCategory.technical,
        priority: TicketPriority.urgent,
        status: TicketStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        lastUpdate: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      Ticket(
        id: '5678',
        subject: 'Dúvida sobre adubação',
        description: 'Qual a quantidade recomendada para milho?',
        category: TicketCategory.agronomic,
        priority: TicketPriority.normal,
        status: TicketStatus.resolved,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        lastUpdate: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}
