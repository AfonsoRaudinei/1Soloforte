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
  final _phone2Controller = TextEditingController(); // Added Second Phone
  final _cpfCnpjController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedState;
  final String _selectedType = 'producer';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _phone2Controller.dispose();
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(isEditing ? 'Editar Produtor' : 'Novo Produtor'),
        actions: [
          TextButton.icon(
            onPressed: _saveClient,
            icon: const Icon(Icons.check, color: AppColors.primary),
            label: const Text(
              'Salvar',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Picker
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Foto do Produtor',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    AvatarPicker(
                      initials: _getInitials(_nameController.text),
                      onImageSelected: (_) {
                        // TODO: Implement avatar upload when backend is ready
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Text('Informações Básicas', style: AppTypography.h4),
              const Divider(),
              const SizedBox(height: 16),

              _buildTextField(
                _nameController,
                "Nome Completo *",
                Icons.person,
                true,
              ),
              const SizedBox(height: 16),
              MaskedTextInput(
                controller: _cpfCnpjController,
                label: 'CPF/CNPJ',
                hint: '000.000.000-00',
                maskType: MaskType.cpfCnpj,
                prefixIcon: Icons.badge,
              ),
              const SizedBox(height: 16),
              _buildTextField(_emailController, "Email", Icons.email, false),
              const SizedBox(height: 16),

              MaskedTextInput(
                controller: _phoneController,
                label: 'Telefone Principal *',
                hint: '(00) 00000-0000',
                maskType: MaskType.phone,
                required: true,
                prefixIcon: Icons.phone,
              ),
              const SizedBox(height: 16),
              MaskedTextInput(
                controller: _phone2Controller,
                label: 'Telefone Secundário',
                hint: '(00) 00000-0000',
                maskType: MaskType.phone,
                prefixIcon: Icons.phone_iphone,
              ),
              const SizedBox(height: 32),

              Text('Endereço', style: AppTypography.h4),
              const Divider(),
              const SizedBox(height: 16),
              CityAutocomplete(
                controller: _cityController,
                label: 'Cidade *',
                hint: 'Selecione a cidade',
                required: true,
                initialState: _selectedState,
                onCitySelected: (city, state) {
                  setState(() {
                    _selectedState = state;
                    _stateController.text = state;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _stateController,
                'Estado *',
                Icons.map,
                true,
                width: 100,
              ), // Small field for UF

              const SizedBox(height: 32),

              Text('Observações', style: AppTypography.h4),
              const Divider(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Cliente desde 2020...',
                ),
              ),

              const SizedBox(height: 32),

              // Bottom Buttons (Cancel / Save - redundant with header but requested)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveClient,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool required, {
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        validator: required
            ? (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final client = Client(
        id: widget.clientId ?? const Uuid().v4(),
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        cpfCnpj: _cpfCnpjController.text,
        address: _addressController
            .text, // Not in form in new layout? I'll keep it empty or use city/state
        city: _cityController.text,
        state: _stateController.text,
        type: _selectedType,
        status: 'active',
        lastActivity: DateTime.now(),
        notes: _notesController.text,
      );

      await ref.read(clientsControllerProvider.notifier).addClient(client);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produtor salvo!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
