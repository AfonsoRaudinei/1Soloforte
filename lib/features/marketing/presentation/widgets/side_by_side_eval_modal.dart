import 'package:flutter/material.dart';

class SideBySideEvalModal extends StatefulWidget {
  final double latitude;
  final double longitude;

  const SideBySideEvalModal({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<SideBySideEvalModal> createState() => _SideBySideEvalModalState();
}

class _SideBySideEvalModalState extends State<SideBySideEvalModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Colors from CSS
  static const Color kSfDark = Color(0xFF1E3A2F);
  static const Color kSfDarkDeep = Color(0xFF0F2417);
  static const Color kSfGreen = Color(0xFF4ADE80);
  static const Color kSfGreenDark = Color(0xFF22C55E);
  static const Color kGray900 = Color(0xFF1D1D1F);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 60,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kSfDark, kSfDarkDeep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COMPARATIVO',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Avaliação Lado a Lado',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Text(
                    'Compare duas áreas ou tratamentos diferentes para demonstrar a eficácia.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // Simple Fields Placeholder
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título do Comparativo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Column(
                            children: [
                              Text(
                                'Lado A (Controle)',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Icon(Icons.close, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kSfGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kSfGreen),
                          ),
                          child: const Column(
                            children: [
                              Text(
                                'Lado B (Tratado)',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Icon(Icons.check, color: kSfGreenDark),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notas de Observação',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'type': 'side_by_side',
                          'title': _titleController.text,
                          'description': _descriptionController.text,
                          'latitude': widget.latitude,
                          'longitude': widget.longitude,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('✅ Avaliação Salva!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: kSfGreenDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Salvar Comparativo',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
