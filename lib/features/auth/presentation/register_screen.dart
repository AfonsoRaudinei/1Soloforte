import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/shared/widgets/primary_button.dart';
import 'package:soloforte_app/shared/widgets/custom_text_input.dart';
import 'package:soloforte_app/core/validators/input_validators.dart';
import 'providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  String? _accountType;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _cepController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar Dados'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text('Verifique se os dados estão corretos:'),
                const SizedBox(height: 16),
                _buildInfoRow('Nome:', _nameController.text),
                _buildInfoRow('Email:', _emailController.text),
                _buildInfoRow('Tipo:', _accountType?.toUpperCase() ?? ''),
                if (_phoneController.text.isNotEmpty)
                  _buildInfoRow('Telefone:', _phoneController.text),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Voltar e Editar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _submitRegistration();
              },
              child: const Text('Confirmar e Criar'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _submitRegistration() async {
    try {
      await ref
          .read(authControllerProvider)
          .register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
          );

      if (mounted) {}
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Criar Conta',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Junte-se ao SoloForte',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Nome Completo
                  CustomTextInput(
                    label: 'Nome Completo *',
                    hint: 'João Silva',
                    controller: _nameController,
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: (v) => Validators.required(v, fieldName: 'Nome'),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  CustomTextInput(
                    label: 'Email *',
                    hint: 'seu@email.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),

                  // Senha
                  CustomTextInput(
                    label: 'Senha *',
                    hint: '........',
                    controller: _passwordController,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Mín. 8 caracteres, maiúsculas, minúsculas e números',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Confirmar Senha
                  CustomTextInput(
                    label: 'Confirmar Senha *',
                    hint: '........',
                    controller: _confirmPasswordController,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Telefone
                  CustomTextInput(
                    label: 'Telefone',
                    hint: '(00) 00000-0000',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        v != null && v.isNotEmpty ? Validators.phone(v) : null,
                  ),
                  const SizedBox(height: 16),

                  // CEP
                  CustomTextInput(
                    label: 'CEP',
                    hint: '00000-000',
                    controller: _cepController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.location_on_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // Cidade
                  CustomTextInput(
                    label: 'Cidade (Opcional)',
                    hint: 'Sua cidade',
                    controller: _cityController,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // Estado
                  CustomTextInput(
                    label: 'Estado (Opcional)',
                    hint: 'UF',
                    controller: _stateController,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // Tipo de Conta
                  Text(
                    'Tipo de Conta *',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _accountType,
                    decoration: InputDecoration(
                      hintText: 'Selecione o tipo de conta',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.gray100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'produtor',
                        child: Row(
                          children: [Text('🌾 '), Text('Produtor Rural')],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'consultor',
                        child: Row(
                          children: [
                            Text('👨‍🌾 '),
                            Text('Consultor Agronômico'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'empresa',
                        child: Row(children: [Text('🏢 '), Text('Empresa')]),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _accountType = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione o tipo de conta';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Botão Criar Conta
                  PrimaryButton(
                    text: 'Criar Conta',
                    onPressed: _handleRegister,
                  ),

                  const SizedBox(height: 24),

                  // Link para Login
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Já tem uma conta? ',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => context.go('/login'),
                              child: Text(
                                'Fazer Login',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
