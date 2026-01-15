import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de Uso'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Termos de Uso - SoloForte',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Estes termos regem o uso do aplicativo SoloForte. Ao acessar, você concorda com as condições abaixo.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              '1. Licença de Uso',
              'Concedemos uma licença limitada, não exclusiva e intransferível para uso do aplicativo para fins de gestão agrícola.',
            ),

            _buildSection(
              context,
              '2. Responsabilidades do Usuário',
              'Você é responsável por manter a confidencialidade de sua conta e senha. O uso indevido do sistema é proibido.',
            ),

            _buildSection(
              context,
              '3. Propriedade Intelectual',
              'Todo o conteúdo, design e código do SoloForte são propriedade exclusiva da SoloForte.',
            ),

            _buildSection(
              context,
              '4. Disponibilidade',
              'Nos esforçamos para manter o serviço disponível 24/7, mas não garantimos disponibilidade ininterrupta.',
            ),

            _buildSection(
              context,
              '5. Alterações',
              'Podemos atualizar estes termos a qualquer momento. O uso contínuo implica aceitação.',
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Última atualização: Janeiro 2026',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(content, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
