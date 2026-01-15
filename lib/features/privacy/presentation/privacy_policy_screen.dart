import 'package:flutter/material.dart';
import '../../../core/services/secure_storage_service.dart';

/// Privacy Policy Screen
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Política de Privacidade')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Política de Privacidade - SoloForte',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            Text(
              'Última atualização: Dezembro 2024',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),

            _buildSection(context, 'Dados Coletados', [
              'Email e nome (para autenticação)',
              'Localização (para registro de check-ins)',
              'Fotos (para relatórios e ocorrências)',
              'Dados de uso (para melhorias do app)',
            ]),

            _buildSection(context, 'Como Usamos Seus Dados', [
              'Autenticação e segurança da conta',
              'Funcionalidades do aplicativo',
              'Melhorias de experiência do usuário',
              'Comunicação sobre atualizações',
            ]),

            _buildSection(context, 'Compartilhamento de Dados', [
              'Não vendemos seus dados pessoais',
              'Compartilhamos apenas com sua empresa',
              'Usamos serviços terceiros (AWS, Sentry) com proteção adequada',
            ]),

            _buildSection(context, 'Seus Direitos (LGPD)', [
              'Acessar seus dados pessoais',
              'Corrigir dados incorretos',
              'Solicitar exclusão de dados',
              'Revogar consentimento',
              'Portabilidade de dados',
            ]),

            _buildSection(context, 'Segurança', [
              'Criptografia AES-256 para dados sensíveis',
              'SSL/TLS para comunicação',
              'Autenticação biométrica disponível',
              'Monitoramento de segurança 24/7',
            ]),

            _buildSection(context, 'Retenção de Dados', [
              'Mantemos seus dados enquanto sua conta estiver ativa',
              'Após exclusão, dados são removidos em até 30 dias',
              'Backups são mantidos por 90 dias',
            ]),

            const SizedBox(height: 24),

            Text('Contato', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Email: privacidade@soloforte.com'),
            const Text('DPO: dpo@soloforte.com'),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(item)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Consent Manager
class ConsentManager {
  static Future<bool> hasConsented() async {
    final consent = await SecureStorageService.read('privacy_consent');
    return consent == 'true';
  }

  static Future<void> requestConsent(BuildContext context) async {
    if (await hasConsented()) return;
    if (!context.mounted) return;

    final consent = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Termos de Uso e Privacidade'),
        content: const SingleChildScrollView(
          child: Text(
            'Ao continuar, você concorda com nossa Política de Privacidade '
            'e Termos de Uso.\n\n'
            'Coletamos dados necessários para o funcionamento do app, '
            'incluindo email, localização e fotos.\n\n'
            'Você pode revogar seu consentimento a qualquer momento.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Recusar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
            child: const Text('Ler Política'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Aceitar'),
          ),
        ],
      ),
    );

    if (consent == true) {
      await SecureStorageService.write('privacy_consent', 'true');
      await SecureStorageService.write(
        'consent_date',
        DateTime.now().toIso8601String(),
      );
    }
  }

  static Future<void> revokeConsent() async {
    await SecureStorageService.delete('privacy_consent');
    await SecureStorageService.delete('consent_date');
  }
}
