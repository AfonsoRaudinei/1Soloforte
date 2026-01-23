import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'roi_calculator.dart';

class RoiEditorWidget extends StatefulWidget {
  final VoidCallback onDelete;

  // Callback para retornar os dados para o pai se necessário
  // Por enquanto, o estado é local, mas em um formulário real, os controllers deveriam ser passados ou acessíveis.
  // Para este escopo "modular", o widget gerencia seus dados visualmente.

  const RoiEditorWidget({super.key, required this.onDelete});

  @override
  State<RoiEditorWidget> createState() => _RoiEditorWidgetState();
}

class _RoiEditorWidgetState extends State<RoiEditorWidget> {
  final _investmentController = TextEditingController();
  final _returnController = TextEditingController();
  double _roiPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _investmentController.addListener(_calculate);
    _returnController.addListener(_calculate);
  }

  @override
  void dispose() {
    _investmentController.dispose();
    _returnController.dispose();
    super.dispose();
  }

  void _calculate() {
    final investment = double.tryParse(_investmentController.text) ?? 0.0;
    final ret = double.tryParse(_returnController.text) ?? 0.0;

    setState(() {
      _roiPercentage = RoiCalculator.calculate(
        investment: investment,
        returnVal: ret,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF34C759), Color(0xFF30D158)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ROI',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: widget.onDelete,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Grid inputs
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _buildInput(
                  label: 'Investimento (R\$)',
                  controller: _investmentController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInput(
                  label: 'Retorno (R\$)',
                  controller: _returnController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'ROI',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        RoiCalculator.formatPercentage(_roiPercentage),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 15, color: Color(0xFF1C1C1E)),
          decoration: InputDecoration(
            hintText: '0.00',
            fillColor: Colors.white.withOpacity(0.95),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
