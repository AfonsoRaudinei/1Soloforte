import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

enum MaskType { cpf, cnpj, cpfCnpj, phone, cep, custom }

class MaskedTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final MaskType maskType;
  final String? customMask;
  final bool required;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const MaskedTextInput({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    required this.maskType,
    this.customMask,
    this.required = false,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
  });

  @override
  State<MaskedTextInput> createState() => _MaskedTextInputState();
}

class _MaskedTextInputState extends State<MaskedTextInput> {
  late MaskTextInputFormatter _maskFormatter;
  late MaskTextInputFormatter? _alternateMaskFormatter;

  @override
  void initState() {
    super.initState();
    _initializeMask();
  }

  void _initializeMask() {
    switch (widget.maskType) {
      case MaskType.cpf:
        _maskFormatter = MaskTextInputFormatter(
          mask: '###.###.###-##',
          filter: {"#": RegExp(r'[0-9]')},
        );
        _alternateMaskFormatter = null;
        break;

      case MaskType.cnpj:
        _maskFormatter = MaskTextInputFormatter(
          mask: '##.###.###/####-##',
          filter: {"#": RegExp(r'[0-9]')},
        );
        _alternateMaskFormatter = null;
        break;

      case MaskType.cpfCnpj:
        // CPF mask
        _maskFormatter = MaskTextInputFormatter(
          mask: '###.###.###-##',
          filter: {"#": RegExp(r'[0-9]')},
        );
        // CNPJ mask
        _alternateMaskFormatter = MaskTextInputFormatter(
          mask: '##.###.###/####-##',
          filter: {"#": RegExp(r'[0-9]')},
        );
        break;

      case MaskType.phone:
        _maskFormatter = MaskTextInputFormatter(
          mask: '(##) #####-####',
          filter: {"#": RegExp(r'[0-9]')},
        );
        _alternateMaskFormatter = null;
        break;

      case MaskType.cep:
        _maskFormatter = MaskTextInputFormatter(
          mask: '#####-###',
          filter: {"#": RegExp(r'[0-9]')},
        );
        _alternateMaskFormatter = null;
        break;

      case MaskType.custom:
        if (widget.customMask != null) {
          _maskFormatter = MaskTextInputFormatter(
            mask: widget.customMask!,
            filter: {"#": RegExp(r'[0-9]')},
          );
        } else {
          _maskFormatter = MaskTextInputFormatter();
        }
        _alternateMaskFormatter = null;
        break;
    }
  }

  List<TextInputFormatter> _getFormatters() {
    // Para CPF/CNPJ, precisamos alternar entre as máscaras
    if (widget.maskType == MaskType.cpfCnpj) {
      return [
        _CpfCnpjFormatter(
          cpfFormatter: _maskFormatter,
          cnpjFormatter: _alternateMaskFormatter!,
        ),
      ];
    }

    return [_maskFormatter];
  }

  String? _defaultValidator(String? value) {
    if (widget.required && (value == null || value.isEmpty)) {
      return '${widget.label} é obrigatório';
    }

    if (value != null && value.isNotEmpty) {
      final unmasked = _maskFormatter.getUnmaskedText();

      switch (widget.maskType) {
        case MaskType.cpf:
          if (unmasked.length != 11) {
            return 'CPF inválido';
          }
          if (!_isValidCPF(unmasked)) {
            return 'CPF inválido';
          }
          break;

        case MaskType.cnpj:
          if (unmasked.length != 14) {
            return 'CNPJ inválido';
          }
          if (!_isValidCNPJ(unmasked)) {
            return 'CNPJ inválido';
          }
          break;

        case MaskType.cpfCnpj:
          if (unmasked.length == 11) {
            if (!_isValidCPF(unmasked)) {
              return 'CPF inválido';
            }
          } else if (unmasked.length == 14) {
            if (!_isValidCNPJ(unmasked)) {
              return 'CNPJ inválido';
            }
          } else {
            return 'CPF/CNPJ inválido';
          }
          break;

        case MaskType.phone:
          if (unmasked.length != 11) {
            return 'Telefone inválido';
          }
          break;

        case MaskType.cep:
          if (unmasked.length != 8) {
            return 'CEP inválido';
          }
          break;

        case MaskType.custom:
          break;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      inputFormatters: _getFormatters(),
      keyboardType: widget.keyboardType ?? TextInputType.number,
      validator: widget.validator ?? _defaultValidator,
      decoration: InputDecoration(
        labelText: widget.label + (widget.required ? ' *' : ''),
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: AppColors.primary)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTypography.bodyMedium,
        hintStyle: AppTypography.bodySmall.copyWith(color: Colors.grey[400]),
      ),
    );
  }

  // Validação de CPF
  bool _isValidCPF(String cpf) {
    if (cpf.length != 11) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    // Calcula primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int digit1 = 11 - (sum % 11);
    if (digit1 >= 10) digit1 = 0;

    // Calcula segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    int digit2 = 11 - (sum % 11);
    if (digit2 >= 10) digit2 = 0;

    return cpf[9] == digit1.toString() && cpf[10] == digit2.toString();
  }

  // Validação de CNPJ
  bool _isValidCNPJ(String cnpj) {
    if (cnpj.length != 14) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cnpj)) return false;

    // Calcula primeiro dígito verificador
    List<int> weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      sum += int.parse(cnpj[i]) * weights1[i];
    }
    int digit1 = sum % 11 < 2 ? 0 : 11 - (sum % 11);

    // Calcula segundo dígito verificador
    List<int> weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    sum = 0;
    for (int i = 0; i < 13; i++) {
      sum += int.parse(cnpj[i]) * weights2[i];
    }
    int digit2 = sum % 11 < 2 ? 0 : 11 - (sum % 11);

    return cnpj[12] == digit1.toString() && cnpj[13] == digit2.toString();
  }
}

// Formatter customizado para alternar entre CPF e CNPJ
class _CpfCnpjFormatter extends TextInputFormatter {
  final MaskTextInputFormatter cpfFormatter;
  final MaskTextInputFormatter cnpjFormatter;

  _CpfCnpjFormatter({required this.cpfFormatter, required this.cnpjFormatter});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final unmasked = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Se tem mais de 11 dígitos, usa máscara de CNPJ
    if (unmasked.length > 11) {
      return cnpjFormatter.formatEditUpdate(oldValue, newValue);
    }

    // Caso contrário, usa máscara de CPF
    return cpfFormatter.formatEditUpdate(oldValue, newValue);
  }
}
