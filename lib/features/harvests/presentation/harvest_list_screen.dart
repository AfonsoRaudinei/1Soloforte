import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../domain/harvest_model.dart';

class HarvestListScreen extends StatefulWidget {
  const HarvestListScreen({super.key});

  @override
  State<HarvestListScreen> createState() => _HarvestListScreenState();
}

class _HarvestListScreenState extends State<HarvestListScreen> {
  // Mock Data aligned with new Harvest model
  final List<Harvest> _harvests = [
    Harvest(
      id: '1',
      areaId: '1',
      areaName: 'Talhão Norte',
      plantedDate: DateTime.now().subtract(const Duration(days: 120)),
      harvestDate: DateTime.now().subtract(const Duration(days: 2)),
      cropType: 'Soja',
      plantedAreaHa: 50.0,
      totalProductionBags: 3000.0,
      totalCost: 150000.0,
      status: 'harvested',
      notes: ['Armazenado no Silo A'],
    ),
    Harvest(
      id: '2',
      areaId: '2',
      areaName: 'Lavoura Sul',
      plantedDate: DateTime.now().subtract(const Duration(days: 100)),
      harvestDate: null,
      cropType: 'Milho',
      plantedAreaHa: 80.0,
      totalProductionBags: 0.0,
      totalCost: 200000.0,
      status: 'active',
      notes: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _harvests.isEmpty
        ? const Center(child: Text('Nenhum registro de safra encontrado.'))
        : ListView.separated(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            itemCount: _harvests.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final harvest = _harvests[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.shade100,
                  child: const Icon(Icons.agriculture, color: Colors.orange),
                ),
                title: Text(harvest.areaName),
                subtitle: Text(
                  '${harvest.cropType} • ${harvest.status == 'active' ? 'Em andamento' : 'Colhido em ${DateFormat('dd/MM').format(harvest.harvestDate ?? DateTime.now())}'}',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (harvest.totalProductionBags > 0)
                      Text(
                        '${harvest.totalProductionBags.toStringAsFixed(0)} sc',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    else
                      const Text(
                        '-- sc',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    Text(
                      '${harvest.plantedAreaHa} ha',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
