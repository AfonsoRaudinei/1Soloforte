import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/clients/domain/client_model.dart';
import 'package:soloforte_app/features/clients/presentation/clients_controller.dart';
import 'package:soloforte_app/shared/widgets/avatar_picker.dart';
import 'package:soloforte_app/shared/widgets/masked_text_input.dart';
import 'package:soloforte_app/shared/widgets/city_autocomplete.dart';
import 'package:uuid/uuid.dart';

class ClientFormScreen extends ConsumerStatefulWidget {
  final String? clientId; // null = novo cliente

  const ClientFormScreen({super.key, this.clientId});

  @override
  ConsumerState<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends ConsumerState<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _notesController = TextEditingController();

  File? _selectedAvatar;
  String? _selectedState;
  String _selectedType = 'producer';
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    // TODO: Se clientId != null, carregar dados do cliente
    _setupListeners();
  }

  void _setupListeners() {
    _nameController.addListener(_markAsChanged);
    _emailController.addListener(_markAsChanged);
    _phoneController.addListener(_markAsChanged);
    _cpfCnpjController.addListener(_markAsChanged);
    _addressController.addListener(_markAsChanged);
    _cityController.addListener(_markAsChanged);
    _stateController.addListener(_markAsChanged);
    _notesController.addListener(_markAsChanged);
  }

  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cpfCnpjController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.clientId != null;

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await _showDiscardDialog();
        if (shouldPop == true && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(isEditing ? 'Editar Cliente' : 'Novo Cliente'),
          actions: [
            if (_hasUnsavedChanges)
              TextButton(
                onPressed: _saveDraft,
                child: const Text(
                  'Salvar Rascunho',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Center(
                  child: AvatarPicker(
                    initials: _nameController.text.isNotEmpty
                        ? _getInitials(_nameController.text)
                        : '?',
                    onImageSelected: (file) {
                      setState(() {
                        _selectedAvatar = file;
                        _markAsChanged();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Informações Básicas
                _buildSectionTitle('Informações Básicas'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: _buildInputDecoration(
                    label: 'Nome *',
                    hint: 'Nome do cliente ou fazenda',
                    icon: Icons.person,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome é obrigatório';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}), // Para atualizar iniciais
                ),
                const SizedBox(height: 16),

                // Tipo
                Text(
                  'Tipo *',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'producer',
                      label: Text('Produtor'),
                      icon: Icon(Icons.agriculture),
                    ),
                    ButtonSegment(
                      value: 'consultant',
                      label: Text('Consultor'),
                      icon: Icon(Icons.business_center),
                    ),
                  ],
                  selected: {_selectedType},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedType = newSelection.first;
                      _markAsChanged();
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.primary;
                      }
                      return Colors.grey[200];
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.grey[700];
                    }),
                  ),
                ),
                const SizedBox(height: 24),

                // Contato
                _buildSectionTitle('Contato'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration(
                    label: 'Email *',
                    hint: 'email@exemplo.com',
                    icon: Icons.email,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email é obrigatório';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                MaskedTextInput(
                  controller: _phoneController,
                  label: 'Telefone',
                  hint: '(00) 00000-0000',
                  maskType: MaskType.phone,
                  required: true,
                  prefixIcon: Icons.phone,
                ),
                const SizedBox(height: 16),
                MaskedTextInput(
                  controller: _cpfCnpjController,
                  label: 'CPF/CNPJ',
                  hint: 'CPF ou CNPJ',
                  maskType: MaskType.cpfCnpj,
                  prefixIcon: Icons.badge,
                ),
                const SizedBox(height: 24),

                // Localização
                _buildSectionTitle('Localização'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: _buildInputDecoration(
                    label: 'Endereço',
                    hint: 'Rua, número, complemento',
                    icon: Icons.home,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                CityAutocomplete(
                  controller: _cityController,
                  label: 'Cidade',
                  hint: 'Digite o nome da cidade',
                  required: true,
                  initialState: _selectedState,
                  onCitySelected: (city, state) {
                    setState(() {
                      _selectedState = state;
                      _stateController.text = state;
                      _markAsChanged();
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stateController,
                  decoration: _buildInputDecoration(
                    label: 'Estado *',
                    hint: 'UF',
                    icon: Icons.map,
                  ),
                  maxLength: 2,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Estado é obrigatório';
                    }
                    if (value.length != 2) {
                      return 'Digite a sigla do estado (ex: SP)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Notas
                _buildSectionTitle('Notas'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: _buildInputDecoration(
                    label: 'Observações',
                    hint: 'Informações adicionais sobre o cliente',
                    icon: Icons.note,
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 32),

                // Botões
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_hasUnsavedChanges) {
                                  final shouldDiscard =
                                      await _showDiscardDialog();
                                  if (shouldDiscard == true &&
                                      context.mounted) {
                                    context.pop();
                                  }
                                } else {
                                  context.pop();
                                }
                              },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveClient,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(isEditing ? 'Salvar' : 'Criar Cliente'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.h4.copyWith(color: AppColors.primary),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    String? hint,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
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
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final client = Client(
        id: widget.clientId ?? const Uuid().v4(),
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        cpfCnpj: _cpfCnpjController.text.isEmpty
            ? null
            : _cpfCnpjController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        type: _selectedType,
        status: 'active',
        lastActivity: DateTime.now(),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        // TODO: Upload avatar para storage e obter URL
      );

      await ref.read(clientsControllerProvider.notifier).addClient(client);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.clientId != null
                  ? 'Cliente atualizado com sucesso!'
                  : 'Cliente criado com sucesso!',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar cliente: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _saveDraft() {
    // TODO: Implementar salvamento de rascunho
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rascunho salvo!'),
        backgroundColor: AppColors.info,
      ),
    );
    setState(() {
      _hasUnsavedChanges = false;
    });
  }

  Future<bool?> _showDiscardDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descartar alterações?'),
        content: const Text(
          'Você tem alterações não salvas. Deseja descartá-las?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );
  }
}
