import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/settings/presentation/widgets/settings_widgets.dart';
import 'providers/settings_provider.dart';
import '../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: settingsAsync.when(
                data: (settings) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      _buildProfileIdentitySection(context, settings),
                      const SizedBox(height: 32),

                      _buildManagementSection(context),
                      const SizedBox(height: 24),

                      _buildVisualStyleSection(
                        context,
                        ref,
                        settings.visualStyle,
                      ),
                      const SizedBox(height: 24),

                      _buildNotificationsSection(context, ref, settings),
                      const SizedBox(height: 24),

                      _buildMapsDataSection(context, ref, settings),
                      const SizedBox(height: 24),

                      _buildAppearanceSection(context),
                      const SizedBox(height: 24),

                      _buildSupportSection(context),
                      const SizedBox(height: 24),

                      _buildPrivacySection(context),
                      const SizedBox(height: 24),

                      _buildAboutSection(context),
                      const SizedBox(height: 48),

                      _buildLogoutSection(context, ref),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) =>
                    Center(child: Text('Erro ao carregar configurações: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- New Section: Management ---
  Widget _buildManagementSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionLabel('GESTÃO & RECURSOS'),
        SettingsCardContainer(
          children: [
            SettingsNavigableRow(
              icon: Icons.agriculture_outlined,
              iconGradient: _greenGradient,
              title: 'Safra',
              subtitle: 'Gerenciar safras e ciclos',
              onTap: () => context.push('/map/settings/harvest'),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E7)),
            SettingsNavigableRow(
              icon: Icons.hub_outlined,
              iconGradient: _purpleGradient,
              title: 'Integrações',
              subtitle: 'Conectar sensores e serviços',
              onTap: () => context.push('/map/settings/integrations'),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E7)),
            SettingsNavigableRow(
              icon: Icons.newspaper_outlined,
              iconGradient: _orangeGradient,
              title: 'Notícias',
              subtitle: 'Atualizações do setor',
              onTap: () => context.push('/map/settings/news'),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E7)),
            SettingsNavigableRow(
              icon: Icons.link,
              iconGradient: _defaultGradient,
              title: 'LinkHub',
              subtitle: 'Acesso rápido',
              onTap: () => context.push('/map/settings/link-hub'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 8, left: 16, right: 16),
      color: const Color(0xFFF2F2F7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/map');
              }
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Configurações',
            style: AppTypography.h2.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gerencie suas preferências',
            style: AppTypography.bodyMedium.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // --- Helpers ---

  static const _defaultGradient = [Colors.blue, Colors.blueAccent];
  static const _purpleGradient = [Colors.purple, Colors.deepPurple];
  static const _orangeGradient = [Colors.orange, Colors.deepOrange];
  static const _greenGradient = [Colors.green, Colors.teal];

  // --- Sections ---

  Widget _buildProfileIdentitySection(BuildContext context, dynamic settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionLabel('IDENTIDADE DA FAZENDA'),
        SettingsCardContainer(
          children: [
            // Logo Upload
            GestureDetector(
              onTap: () => context.push('/map/settings/logo'),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                        image: settings.farmLogoPath != null
                            ? DecorationImage(
                                image: NetworkImage(settings.farmLogoPath!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: settings.farmLogoPath == null
                          ? const Icon(
                              Icons.add_photo_alternate_outlined,
                              color: AppColors.textSecondary,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Logotipo da Fazenda',
                            style: AppTypography.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Toque para alterar o logo exibido nos relatórios',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E7)),

            // Edit Info
            SettingsNavigableRow(
              icon: Icons.edit_note,
              iconGradient: _greenGradient,
              title: 'Informações Cadastrais',
              subtitle: 'CNPJ, Endereço e Contatos',
              onTap: () => context.push('/map/settings/info'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVisualStyleSection(
    BuildContext context,
    WidgetRef ref,
    String currentStyle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionLabel('ESTILO VISUAL'),
        Row(
          children: [
            Expanded(
              child: SettingsStyleOption(
                id: 'ios',
                title: 'Clean iOS',
                subtitle: 'Minimalista e fluido',
                icon: Icons.phone_iphone,
                gradient: _defaultGradient,
                selectedId: currentStyle,
                onSelected: (id) {
                  ref
                      .read(settingsControllerProvider.notifier)
                      .updateSetting(visualStyle: id);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SettingsStyleOption(
                id: 'material',
                title: 'Material 3',
                subtitle: 'Padrão Android',
                icon: Icons.android,
                gradient: _greenGradient,
                selectedId: currentStyle,
                onSelected: (id) {
                  ref
                      .read(settingsControllerProvider.notifier)
                      .updateSetting(visualStyle: id);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(
    BuildContext context,
    WidgetRef ref,
    dynamic settings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionLabel('NOTIFICAÇÕES'),
        SettingsCardContainer(
          children: [
            SettingsSwitchRow(
              icon: Icons.notifications_active_outlined,
              iconGradient: _orangeGradient,
              title: 'Notificações Push',
              subtitle: 'Alertas no dispositivo',
              value: settings.pushNotificationsEnabled,
              onChanged: (val) {
                ref
                    .read(settingsControllerProvider.notifier)
                    .updateSetting(pushNotifications: val);
              },
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E7)),

            SettingsSwitchRow(
              icon: Icons.email_outlined,
              iconGradient: _purpleGradient,
              title: 'Alertas por E-mail',
              subtitle: 'Relatórios diários',
              value: settings.emailNotificationsEnabled,
              onChanged: (val) {
                ref
                    .read(settingsControllerProvider.notifier)
                    .updateSetting(emailNotifications: val);
              },
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E7)),

            SettingsSwitchRow(
              icon: Icons.warning_amber_rounded,
              iconGradient: [Colors.red, Colors.redAccent],
              title: 'Alertas Automáticos',
              subtitle: 'Avisar quando houver risco crítico',
              value: settings.automaticAlertsEnabled,
              onChanged: (val) {
                ref
                    .read(settingsControllerProvider.notifier)
                    .updateSetting(automaticAlerts: val);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMapsDataSection(
    BuildContext context,
    WidgetRef ref,
    dynamic settings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionLabel('MAPAS E DADOS'),
        SettingsCardContainer(
          children: [
            SettingsSwitchRow(
              icon: Icons.cloud_off,
              iconGradient: [Colors.grey, Colors.blueGrey],
              title: 'Modo Offline',
              subtitle: 'Baixar mapas para uso sem internet',
              value: settings.offlineModeEnabled,
              onChanged: (val) {
                ref
                    .read(settingsControllerProvider.notifier)
                    .updateSetting(offlineMode: val);
              },
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E7)),

            SettingsSwitchRow(
              icon: Icons.sync,
              iconGradient: _defaultGradient,
              title: 'Sincronização Automática',
              subtitle: 'Manter dados atualizados',
              value: settings.autoSyncEnabled,
              onChanged: (val) {
                ref
                    .read(settingsControllerProvider.notifier)
                    .updateSetting(autoSync: val);
              },
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E7)),

            SettingsNavigableRow(
              icon: Icons.storage,
              iconGradient: _orangeGradient,
              title: 'Gerenciar Armazenamento',
              subtitle: 'Limpar cache de mapas e dados',
              onTap: () => context.push('/map/settings/storage'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionLabel('APARÊNCIA'),
        SettingsCardContainer(
          children: [
            SettingsNavigableRow(
              icon: Icons.language,
              iconGradient: _greenGradient,
              title: 'Idioma',
              subtitle: 'Português (BR)',
              onTap: () => context.push('/map/settings/language'),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E7)),
            SettingsNavigableRow(
              icon: Icons.dark_mode_outlined,
              iconGradient: [Colors.black87, Colors.black54],
              title: 'Tema Escuro',
              subtitle: 'Sistema',
              onTap: () => context.push('/map/settings/theme'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionLabel('SUPORTE'),
        SettingsCardContainer(
          children: [
            SettingsNavigableRow(
              icon: Icons.help_outline,
              iconGradient: _defaultGradient,
              title: 'Central de Ajuda',
              subtitle: 'Perguntas frequentes e tutoriais',
              onTap: () {
                context.push('/map/settings/help');
              },
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E7)),
            SettingsNavigableRow(
              icon: Icons.chat_bubble_outline,
              iconGradient: _purpleGradient,
              title: 'Falar com Suporte',
              subtitle: 'Atendimento via chat',
              onTap: () {
                context.push('/map/settings/contact');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrivacySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionLabel('PRIVACIDADE'),
        SettingsCardContainer(
          children: [
            SettingsNavigableRow(
              icon: Icons.lock_outline,
              iconGradient: _orangeGradient,
              title: 'Alterar Senha',
              subtitle: 'Segurança da conta',
              onTap: () {
                context.push('/map/settings/password');
              },
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E7)),
            SettingsNavigableRow(
              icon: Icons.description_outlined,
              iconGradient: _defaultGradient,
              title: 'Termos de Uso',
              subtitle: 'Regras de utilização',
              onTap: () {
                context.push('/map/settings/terms');
              },
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E7)),
            SettingsNavigableRow(
              icon: Icons.privacy_tip_outlined,
              iconGradient: _purpleGradient,
              title: 'Política de Privacidade',
              subtitle: 'Como usamos seus dados',
              onTap: () {
                context.push('/privacy-policy');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      children: [
        Text('SoloForte v1.0.0 (Build 42)', style: AppTypography.caption),
        const SizedBox(height: 4),
        Text(
          'Desenvolvido com ❤️ para o Agro',
          style: AppTypography.caption.copyWith(color: AppColors.textDisabled),
        ),
      ],
    );
  }

  Widget _buildLogoutSection(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          // Implement logout
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Sair do Aplicativo?'),
              content: const Text('Você precisará fazer login novamente.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await ref.read(authServiceProvider).logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  child: const Text(
                    'Sair',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Sair da Conta'),
      ),
    );
  }
}
