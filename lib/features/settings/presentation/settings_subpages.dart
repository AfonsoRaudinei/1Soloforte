import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'providers/settings_provider.dart';
import 'package:soloforte_app/features/settings/data/marketing_plans_repository.dart';
import 'package:soloforte_app/features/settings/domain/entities/app_settings.dart';
import 'package:soloforte_app/features/settings/domain/entities/marketing_plan.dart';
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

class MarketingPlansSettingsScreen extends ConsumerStatefulWidget {
  const MarketingPlansSettingsScreen({super.key});

  @override
  ConsumerState<MarketingPlansSettingsScreen> createState() =>
      _MarketingPlansSettingsScreenState();
}

class _MarketingPlansSettingsScreenState
    extends ConsumerState<MarketingPlansSettingsScreen> {
  final MarketingPlansRepository _repository = MarketingPlansRepository();
  final Map<MarketingPlanLevel, _PlanDraft> _drafts = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  @override
  void dispose() {
    for (final draft in _drafts.values) {
      draft.dispose();
    }
    super.dispose();
  }

  Future<void> _loadPlans() async {
    try {
      final plans = await _repository.getPlans();
      for (final plan in plans) {
        _drafts[plan.level] = _PlanDraft.fromPlan(plan);
      }
      _loading = false;
      _error = null;
    } catch (e) {
      _loading = false;
      _error = e.toString();
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _savePlans() async {
    final plans = MarketingPlanLevel.values
        .map((level) => _drafts[level]!.toPlan(level))
        .toList();
    await _repository.savePlans(plans);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Planos de marketing atualizados.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _BaseSettingsPage(
      title: 'Marketing',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Erro: $_error'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Planos de Marketing',
                      style: AppTypography.h4.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Area administrativa. Valores internos, sem impacto no mapa.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPlanCard(MarketingPlanLevel.bronze),
                    const SizedBox(height: 16),
                    _buildPlanCard(MarketingPlanLevel.prata),
                    const SizedBox(height: 16),
                    _buildPlanCard(MarketingPlanLevel.ouro),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _savePlans,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Salvar alteracoes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nao e possivel criar novos niveis.',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
    );
  }

  Widget _buildPlanCard(MarketingPlanLevel level) {
    final draft = _drafts[level]!;
    final label = _levelLabel(level);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: AppTypography.h4.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Switch(
                value: draft.isActive,
                onChanged: (value) => setState(() {
                  draft.isActive = value;
                }),
              ),
              Text(
                draft.isActive ? 'Ativo' : 'Inativo',
                style: AppTypography.bodySmall.copyWith(
                  color: draft.isActive ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Descricao comercial',
            style: AppTypography.bodySmall.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: draft.descriptionController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Ex: Destaque basico no mapa',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Valor de referencia',
            style: AppTypography.bodySmall.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: draft.valueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: '0.00',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Unidade de cobranca',
            style: AppTypography.bodySmall.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<MarketingBillingUnit>(
            initialValue: draft.billingUnit,
            items: const [
              DropdownMenuItem(
                value: MarketingBillingUnit.perPublication,
                child: Text('Por publicacao'),
              ),
              DropdownMenuItem(
                value: MarketingBillingUnit.perPeriod,
                child: Text('Por periodo'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => draft.billingUnit = value);
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  String _levelLabel(MarketingPlanLevel level) {
    switch (level) {
      case MarketingPlanLevel.bronze:
        return 'Bronze';
      case MarketingPlanLevel.prata:
        return 'Prata';
      case MarketingPlanLevel.ouro:
        return 'Ouro';
    }
  }
}

class _PlanDraft {
  final TextEditingController descriptionController;
  final TextEditingController valueController;
  MarketingBillingUnit billingUnit;
  bool isActive;

  _PlanDraft({
    required this.descriptionController,
    required this.valueController,
    required this.billingUnit,
    required this.isActive,
  });

  factory _PlanDraft.fromPlan(MarketingPlan plan) {
    return _PlanDraft(
      descriptionController: TextEditingController(text: plan.description),
      valueController: TextEditingController(
        text: plan.price.toStringAsFixed(2),
      ),
      billingUnit: plan.unit,
      isActive: plan.isActive,
    );
  }

  MarketingPlan toPlan(MarketingPlanLevel level) {
    final parsed = double.tryParse(
          valueController.text.replaceAll(',', '.'),
        ) ??
        0;
    return MarketingPlan(
      level: level,
      description: descriptionController.text.trim(),
      price: parsed,
      unit: billingUnit,
      isActive: isActive,
    );
  }

  void dispose() {
    descriptionController.dispose();
    valueController.dispose();
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
