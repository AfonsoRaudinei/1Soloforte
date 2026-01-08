import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/features/visits/presentation/widgets/active_visit/visit_section.dart';
import 'package:soloforte_app/l10n/generated/app_localizations.dart' as l10n;

class VisitHeader extends StatelessWidget {
  final TextEditingController produtorCtrl;
  final TextEditingController propriedadeCtrl;
  final TextEditingController areaCtrl;
  final TextEditingController cultivarCtrl;
  final TextEditingController tecnicoCtrl;
  final TextEditingController locationCtrl;
  final DateTime visitDate;
  final DateTime? plantDate;
  final int dap;
  final VoidCallback onDateTap;
  final VoidCallback onPlantDateTap;

  const VisitHeader({
    super.key,
    required this.produtorCtrl,
    required this.propriedadeCtrl,
    required this.areaCtrl,
    required this.cultivarCtrl,
    required this.tecnicoCtrl,
    required this.locationCtrl,
    required this.visitDate,
    required this.plantDate,
    required this.dap,
    required this.onDateTap,
    required this.onPlantDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VisitSectionHeader(title: l10n.AppLocalizations.of(context)!.visitInfo),
        VisitSectionCard(
          child: Column(
            children: [
              _buildRowInput(
                context,
                l10n.AppLocalizations.of(context)!.producer,
                produtorCtrl,
              ),
              const Divider(height: 24),
              _buildRowInput(
                context,
                l10n.AppLocalizations.of(context)!.property,
                propriedadeCtrl,
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onDateTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.AppLocalizations.of(context)!.date,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(visitDate),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildRowInput(
                context,
                l10n.AppLocalizations.of(context)!.areaHa,
                areaCtrl,
                keyboardType: TextInputType.number,
              ),
              const Divider(height: 24),
              _buildRowInput(
                context,
                l10n.AppLocalizations.of(context)!.cultivar,
                cultivarCtrl,
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Text(
                    l10n.AppLocalizations.of(context)!.planting,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: onPlantDateTap,
                    child: Text(
                      plantDate == null
                          ? l10n.AppLocalizations.of(context)!.select
                          : DateFormat('dd/MM/yyyy').format(plantDate!),
                      style: TextStyle(
                        fontSize: 16,
                        color: plantDate == null ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              if (dap > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.AppLocalizations.of(context)!.dapDays(dap),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const Divider(height: 24),
              _buildRowInput(
                context,
                l10n.AppLocalizations.of(context)!.technician,
                tecnicoCtrl,
              ),
              const Divider(height: 24),
              _buildRowInput(
                context,
                l10n.AppLocalizations.of(context)!.locationGps,
                locationCtrl,
                readOnly: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRowInput(
    BuildContext context,
    String label,
    TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
        Expanded(
          child: TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            readOnly: readOnly,
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: l10n.AppLocalizations.of(context)!.typeHere,
              hintStyle: const TextStyle(color: Colors.grey),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
