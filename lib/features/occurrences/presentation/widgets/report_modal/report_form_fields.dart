import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportTextInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  const ReportTextInput({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textAlign: TextAlign.end,
              decoration: InputDecoration.collapsed(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReportDateInput extends StatelessWidget {
  final String label;
  final DateTime? date;
  final ValueChanged<DateTime> onSelect;
  final String placeholder;

  const ReportDateInput({
    super.key,
    required this.label,
    required this.date,
    required this.onSelect,
    this.placeholder = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: date ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (d != null) onSelect(d);
              },
              child: Text(
                date != null
                    ? DateFormat('dd/MM/yyyy').format(date!)
                    : placeholder,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 16,
                  color: date != null ? Colors.black : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReportTextArea extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  const ReportTextArea({
    super.key,
    required this.controller,
    this.hint = 'Digite aqui...',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        maxLines: 3,
        onChanged: onChanged,
        decoration: InputDecoration.collapsed(hintText: hint),
      ),
    );
  }
}
