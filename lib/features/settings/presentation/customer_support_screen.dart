import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/support/data/support_repository.dart';
import 'package:soloforte_app/features/auth/presentation/providers/auth_provider.dart';

class CustomerSupportScreen extends ConsumerStatefulWidget {
  const CustomerSupportScreen({super.key});

  @override
  ConsumerState<CustomerSupportScreen> createState() =>
      _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends ConsumerState<CustomerSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _repository = SupportRepository();
  bool _isLoading = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authStateProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuário não autenticado.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _repository.sendSupportMessage(
        userId: user.userId,
        subject: _subjectController.text,
        message: _messageController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mensagem enviada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao enviar: ${e.toString().replaceAll("Exception: ", "")}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Falar com Suporte'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFF5F5F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Envie sua mensagem e nossa equipe responderá em breve.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Assunto
              TextFormField(
                controller: _subjectController,
                decoration: _inputDecoration('Assunto'),
                validator: (v) =>
                    v?.isNotEmpty == true ? null : 'Informe o assunto',
              ),
              const SizedBox(height: 16),

              // Mensagem
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: _inputDecoration(
                  'Mensagem',
                ).copyWith(alignLabelWithHint: true),
                validator: (v) =>
                    v?.isNotEmpty == true ? null : 'Escreva sua mensagem',
              ),
              const SizedBox(height: 32),

              // Botão Enviar
              FilledButton(
                onPressed: _isLoading ? null : _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Enviar Mensagem'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
    );
  }
}
