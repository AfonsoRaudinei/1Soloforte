import 'package:flutter/material.dart';
import 'report_form_fields.dart';

class VisitInfoSection extends StatelessWidget {
  final TextEditingController produtorController;
  final TextEditingController propriedadeController;
  final TextEditingController areaController;
  final TextEditingController cultivarController;
  final DateTime selectedDate;
  final DateTime? plantingDate;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<DateTime> onPlantingDateChanged;
  final int dap;

  const VisitInfoSection({
    super.key,
    required this.produtorController,
    required this.propriedadeController,
    required this.areaController,
    required this.cultivarController,
    required this.selectedDate,
    required this.plantingDate,
    required this.onDateChanged,
    required this.onPlantingDateChanged,
    required this.dap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReportTextInput(
          label: 'Produtor',
          controller: produtorController,
          hint: 'Nome do produtor',
        ),
        _buildDivider(),
        ReportTextInput(
          label: 'Propriedade',
          controller: propriedadeController,
          hint: 'Nome da fazenda',
        ),
        _buildDivider(),
        ReportDateInput(
          label: 'Data da Visita',
          date: selectedDate,
          onSelect: onDateChanged,
        ),
        _buildDivider(),
        ReportTextInput(
          label: 'Área (ha)',
          controller: areaController,
          hint: '0.00',
          keyboardType: TextInputType.number,
        ),
        _buildDivider(),
        ReportTextInput(
          label: 'Cultivar',
          controller: cultivarController,
          hint: 'Ex: TMG 7062',
        ),
        _buildDivider(),
        ReportDateInput(
          label: 'Data Plantio',
          date: plantingDate,
          onSelect: onPlantingDateChanged,
          placeholder: 'Selecionar',
        ),
        if (plantingDate != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "DAP Calculado: ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "$dap dias",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDivider() => Divider(height: 1, color: Colors.grey.shade200);
}
