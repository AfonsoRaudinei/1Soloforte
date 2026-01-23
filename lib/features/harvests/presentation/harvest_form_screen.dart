import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/shared/widgets/custom_text_input.dart';
import 'package:soloforte_app/shared/widgets/primary_button.dart';

class HarvestFormScreen extends StatefulWidget {
  const HarvestFormScreen({super.key});

  @override
  State<HarvestFormScreen> createState() => _HarvestFormScreenState();
}

class _HarvestFormScreenState extends State<HarvestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientController = TextEditingController();
  final _cropController = TextEditingController();
  final _quantityController = TextEditingController();
  final _storageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveHarvest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Mock delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Safra registrada com sucesso!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Safra'),
        leading: const BackButton(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextInput(
                label: 'Cliente / Fazenda',
                controller: _clientController,
                hint: 'Ex: Fazenda Santa Rita',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              CustomTextInput(
                label: 'Cultura',
                controller: _cropController,
                hint: 'Ex: Soja, Milho',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              CustomTextInput(
                label: 'Quantidade (Toneladas)',
                controller: _quantityController,
                hint: 'Ex: 150.5',
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              CustomTextInput(
                label: 'Local de Armazenamento',
                controller: _storageController,
                hint: 'Ex: Silo A, Armazém Central',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'SALVAR REGISTRO',
                isLoading: _isLoading,
                onPressed: _saveHarvest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
