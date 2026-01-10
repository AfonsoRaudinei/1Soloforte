import 'package:flutter/material.dart';

class ReportConstants {
  static const Map<String, Map<String, dynamic>> stages = {
    'VE': {
      'name': 'VE - Emergência',
      'desc': 'Cotilédones rompem o solo',
      'dap': '0 DAP',
      'icon': Icons.grass,
    },
    'VC': {
      'name': 'VC - Cotilédones',
      'desc': 'Cotilédones totalmente abertos',
      'dap': '3 DAP',
      'icon': Icons.spa,
    },
    'V1': {
      'name': 'V1 - 1ª Trifoliolada',
      'desc': 'Primeira folha trifoliolada',
      'dap': '8 DAP',
      'icon': Icons.eco,
    },
    'V2': {
      'name': 'V2 - 2ª Trifoliolada',
      'desc': 'Segunda folha trifoliolada',
      'dap': '16 DAP',
      'icon': Icons.eco,
    },
    'R1': {
      'name': 'R1 - Florescimento',
      'desc': 'Uma flor aberta',
      'dap': '25 DAP',
      'icon': Icons.local_florist,
    },
    'R5.1': {
      'name': 'R5.1 - Início Ench.',
      'desc': 'Grãos com 10% de granação',
      'dap': '95 DAP',
      'icon': Icons.grain,
    },
    'R8': {
      'name': 'R8 - Maturação',
      'desc': '95% das vagens maduras',
      'dap': '110 DAP',
      'icon': Icons.agriculture,
    },
  };

  static const Map<String, Map<String, dynamic>> categories = {
    'doenca': {
      'title': 'Doença',
      'color': Color(0xFF34C759),
      'icon': Icons.coronavirus,
      'type': 'multi',
      'levels': ['Incidência', 'Severidade'],
    },
    'insetos': {
      'title': 'Insetos',
      'color': Color(0xFFFF2D55),
      'icon': Icons.pest_control,
      'type': 'multi',
      'levels': ['Desfolha', 'Infestação', 'Acamamento'],
    },
    'ervas': {
      'title': 'Ervas Daninhas',
      'color': Color(0xFFFF9500),
      'icon': Icons.grass,
      'type': 'standard',
    },
    'nutrientes': {
      'title': 'Nutrientes',
      'color': Color(0xFF8E8E93),
      'icon': Icons.science,
      'type': 'nutrients',
    },
    'agua': {
      'title': 'Água',
      'color': Color(0xFF30B0C7),
      'icon': Icons.water_drop,
      'type': 'water',
    },
  };
}
