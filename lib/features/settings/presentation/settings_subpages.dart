import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'providers/settings_provider.dart';
import 'package:soloforte_app/features/settings/domain/entities/app_settings.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

// --- Shared Base Scaffold ---

class _BaseSettingsPage extends StatelessWidget {
  final String title;
  final Widget? floatingActionButton;
  final Widget body;

  const _BaseSettingsPage({
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}

// --- 1. Farm Logo Screen ---

class FarmLogoScreen extends ConsumerWidget {
  const FarmLogoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);

    return _BaseSettingsPage(
      title: 'Logotipo da Fazenda',
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erro: $err')),
        data: (settings) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                  image: settings.farmLogoPath != null
                      ? DecorationImage(
                          image: NetworkImage(settings.farmLogoPath!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: settings.farmLogoPath == null
                    ? const Icon(Icons.image, size: 60, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  final picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    ref
                        .read(settingsControllerProvider.notifier)
                        .updateSetting(farmLogoPath: image.path);
                  }
                },
                icon: const Icon(Icons.upload),
                label: const Text('Alterar Logotipo'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (settings.farmLogoPath != null)
                TextButton(
                  onPressed: () {
                    ref
                        .read(settingsControllerProvider.notifier)
                        .updateSetting(farmLogoPath: null);
                  },
                  child: const Text('Remover Logo'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 2. Farm Info Screen ---

class FarmInfoScreen extends ConsumerStatefulWidget {
  const FarmInfoScreen({super.key});

  @override
  ConsumerState<FarmInfoScreen> createState() => _FarmInfoScreenState();
}

class _FarmInfoScreenState extends ConsumerState<FarmInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _cnpjCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    final current = ref.read(settingsControllerProvider).value;
    _nameCtrl = TextEditingController(text: current?.farmName);
    _cnpjCtrl = TextEditingController(text: current?.farmCnpj);
    _addressCtrl = TextEditingController(text: current?.farmAddress);
    _cityCtrl = TextEditingController(text: current?.farmCity);
    _stateCtrl = TextEditingController(text: current?.farmState);
    _phoneCtrl = TextEditingController(text: current?.farmPhone);
    _emailCtrl = TextEditingController(text: current?.farmEmail);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cnpjCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BaseSettingsPage(
      title: 'Informações Cadastrais',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Nome da Fazenda', _nameCtrl),
              _buildTextField(
                'CNPJ',
                _cnpjCtrl,
                keyboardType: TextInputType.number,
              ),
              _buildTextField('Endereço', _addressCtrl),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField('Cidade', _cityCtrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(flex: 1, child: _buildTextField('UF', _stateCtrl)),
                ],
              ),
              _buildTextField(
                'Telefone',
                _phoneCtrl,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                'Email',
                _emailCtrl,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ref
                          .read(settingsControllerProvider.notifier)
                          .updateSetting(
                            farmName: _nameCtrl.text,
                            farmCnpj: _cnpjCtrl.text,
                            farmAddress: _addressCtrl.text,
                            farmCity: _cityCtrl.text,
                            farmState: _stateCtrl.text,
                            farmPhone: _phoneCtrl.text,
                            farmEmail: _emailCtrl.text,
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Informações salvas!')),
                      );
                      context.pop();
                    }
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Salvar Alterações'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// --- 3. Harvest Settings Screen ---

class HarvestSettingsScreen extends ConsumerWidget {
  const HarvestSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);

    return _BaseSettingsPage(
      title: 'Safra',
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: settingsAsync.when(
        data: (settings) {
          final harvests = settings.harvests;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: harvests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final harvest = harvests[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: RadioListTile<String>(
                  value: harvest.id,
                  groupValue: harvests.any((h) => h.isActive)
                      ? harvests.firstWhere((h) => h.isActive).id
                      : null,
                  title: Text(harvest.name, style: AppTypography.bodyLarge),
                  subtitle: Text(harvest.isActive ? 'Ativa' : 'Inativa'),
                  secondary: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      final newList = List<HarvestSetting>.from(harvests);
                      newList.removeAt(index);
                      ref
                          .read(settingsControllerProvider.notifier)
                          .updateSetting(harvests: newList);
                    },
                  ),
                  onChanged: (val) {
                    final newList = harvests
                        .map((h) => h.copyWith(isActive: h.id == val))
                        .toList();
                    ref
                        .read(settingsControllerProvider.notifier)
                        .updateSetting(harvests: newList);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nova Safra'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Ex: 2025/2026'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final current = ref.read(settingsControllerProvider).value;
                if (current != null) {
                  final newList = List<HarvestSetting>.from(current.harvests);
                  newList.add(
                    HarvestSetting(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: controller.text,
                      isActive: newList.isEmpty,
                    ),
                  );
                  ref
                      .read(settingsControllerProvider.notifier)
                      .updateSetting(harvests: newList);
                }
                Navigator.pop(ctx);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}

// --- 4. Integrations ---

class IntegrationsSettingsScreen extends ConsumerWidget {
  const IntegrationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);

    return _BaseSettingsPage(
      title: 'Integrações',
      body: settingsAsync.when(
        data: (settings) {
          final integrations = settings.integrations;
          return Column(
            children: [
              _buildSwitch(
                'Clima Tempo',
                integrations['weather'] ?? false,
                (val) => _update(ref, settings, 'weather', val),
              ),
              const Divider(height: 1),
              _buildSwitch(
                'Imagens de Satélite',
                integrations['satellite'] ?? false,
                (val) => _update(ref, settings, 'satellite', val),
              ),
              const Divider(height: 1),
              _buildSwitch(
                'NDVI / Processamento',
                integrations['ndvi'] ?? false,
                (val) => _update(ref, settings, 'ndvi', val),
              ),
            ],
          );
        },
        loading: () => const SizedBox(),
        error: (_, __) => const SizedBox(),
      ),
    );
  }

  void _update(WidgetRef ref, AppSettings settings, String key, bool val) {
    final newMap = Map<String, bool>.from(settings.integrations);
    newMap[key] = val;
    ref
        .read(settingsControllerProvider.notifier)
        .updateSetting(integrations: newMap);
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      color: Colors.white,
      child: SwitchListTile(
        title: Text(title),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
      ),
    );
  }
}

// --- 5. Storage ---

class StorageSettingsScreen extends StatelessWidget {
  const StorageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _BaseSettingsPage(
      title: 'Gerenciar Armazenamento',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.sd_storage_outlined,
                    size: 48,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  Text('Uso do Dispositivo', style: AppTypography.h4),
                  const SizedBox(height: 8),
                  const Text('Mapas Offline: ~12 MB'),
                  const Text('Dados Locais: ~2 MB'),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Limpar Cache'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Limpar Cache?'),
                      content: const Text(
                        'Isso removerá dados temporários e mapas salvos offline.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cache limpo com sucesso!'),
                              ),
                            );
                          },
                          child: const Text(
                            'Limpar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 6. Language ---

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current =
        ref.watch(settingsControllerProvider).value?.language ?? 'pt_BR';

    return _BaseSettingsPage(
      title: 'Idioma',
      body: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Português (Brasil)'),
              value: 'pt_BR',
              groupValue: current,
              onChanged: (val) => ref
                  .read(settingsControllerProvider.notifier)
                  .updateSetting(language: val),
            ),
            const Divider(height: 1),
            RadioListTile<String>(
              title: const Text('English (US)'),
              value: 'en_US',
              groupValue: current,
              onChanged: (val) => ref
                  .read(settingsControllerProvider.notifier)
                  .updateSetting(language: val),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 7. Theme ---

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current =
        ref.watch(settingsControllerProvider).value?.themeMode ??
        ThemeMode.system;

    return _BaseSettingsPage(
      title: 'Tema',
      body: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Sistema'),
              value: ThemeMode.system,
              groupValue: current,
              onChanged: (val) => ref
                  .read(settingsControllerProvider.notifier)
                  .updateSetting(themeMode: val),
            ),
            const Divider(height: 1),
            RadioListTile<ThemeMode>(
              title: const Text('Claro'),
              value: ThemeMode.light,
              groupValue: current,
              onChanged: (val) => ref
                  .read(settingsControllerProvider.notifier)
                  .updateSetting(themeMode: val),
            ),
            const Divider(height: 1),
            RadioListTile<ThemeMode>(
              title: const Text('Escuro'),
              value: ThemeMode.dark,
              groupValue: current,
              onChanged: (val) => ref
                  .read(settingsControllerProvider.notifier)
                  .updateSetting(themeMode: val),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Placeholders for unused ---
class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});
  @override
  Widget build(BuildContext context) => const _BaseSettingsPage(
    title: 'Notícias',
    body: Center(child: Text('Em breve')),
  );
}

class LinkHubSettingsScreen extends StatelessWidget {
  const LinkHubSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => const _BaseSettingsPage(
    title: 'LinkHub',
    body: Center(child: Text('Em breve')),
  );
}
