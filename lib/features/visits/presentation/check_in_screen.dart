import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/clients/domain/client_model.dart';
import 'package:soloforte_app/features/clients/presentation/clients_controller.dart';
import 'package:soloforte_app/features/visits/presentation/visit_controller.dart';
import 'package:soloforte_app/features/agenda/domain/event_model.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  // Form State
  Client? _selectedClient;
  String? _selectedArea; // Mock string for now
  EventType? _selectedActivityType;
  final TextEditingController _notesController = TextEditingController();

  bool _linkToAgenda = true;
  bool _notifyClient = false;
  File? _arrivalPhoto;

  bool _isLoading = false;
  Position? _currentPosition;

  // Mock Data for Areas (In real app, fetch based on Client)
  final List<String> _mockAreas = [
    'Talhão Norte',
    'Talhão Sul',
    'Área Nova',
    'Sede',
  ];

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _checkLocation() async {
    setState(() => _isLoading = true);
    try {
      // Permission checks logic...
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Handle error
        setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoading = false);
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _arrivalPhoto = File(pickedFile.path);
      });
    }
  }

  Future<void> _handleCheckIn() async {
    if (_selectedClient == null || _selectedActivityType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione Cliente e Atividade obrigatórios'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create Visit
      // We pass the selected client. The active visit controller handles logic.
      await ref
          .read(visitControllerProvider.notifier)
          .checkIn(client: _selectedClient!);

      // Additional logic for Areas/Activity Type would go here in a real implementation
      // For now we just use the existing basic checkIn method

      if (mounted) {
        context.pushReplacement('/visit/active'); // Go to active visit
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check-in realizado com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsState = ref.watch(clientsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar Check-in'),
        actions: [
          TextButton(onPressed: _handleCheckIn, child: const Text('Confirmar')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ), // If locating
                            const SizedBox(width: 8),
                            const Text('[📍 Localizando...]'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentPosition != null
                              ? '${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}'
                              : 'Aguardando GPS...',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.map, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Client Dropdown
            const Text('Cliente/Produtor *'),
            clientsState.when(
              data: (clients) => DropdownButtonFormField<Client>(
                initialValue: _selectedClient,
                isExpanded: true,
                hint: const Text('Selecione'),
                items: clients
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedClient = val),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, s) => Text('Erro ao carregar clientes: $e'),
            ),
            const SizedBox(height: 16),

            // Area Dropdown
            const Text('Área/Talhão *'),
            DropdownButtonFormField<String>(
              initialValue: _selectedArea,
              hint: const Text('Selecione'),
              isExpanded: true,
              items: _mockAreas
                  .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedArea = val),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4, left: 4),
              child: Text(
                'Distância: 150m do ponto salvo',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),

            // Activity Dropdown
            const Text('Tipo de Atividade *'),
            DropdownButtonFormField<EventType>(
              initialValue: _selectedActivityType,
              hint: const Text('Selecione'),
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: EventType.technicalVisit,
                  child: Text('Visita Técnica'),
                ),
                DropdownMenuItem(
                  value: EventType.application,
                  child: Text('Aplicação'),
                ),
                DropdownMenuItem(
                  value: EventType.harvest,
                  child: Text('Colheita'),
                ),
                DropdownMenuItem(
                  value: EventType.maintenance,
                  child: Text('Manutenção'),
                ),
                DropdownMenuItem(value: EventType.custom, child: Text('Outro')),
              ],
              onChanged: (val) => setState(() => _selectedActivityType = val),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Photo
            const Text('Foto (opcional)'),
            GestureDetector(
              onTap: _takePhoto,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: _arrivalPhoto != null
                    ? Image.file(_arrivalPhoto!, fit: BoxFit.cover)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                          Text(
                            'Tirar foto de chegada',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Observations
            const Text('Observações'),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Clima favorável...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 8),
                Text(
                  'Horário: ${TimeOfDay.now().format(context)} (automático)',
                ),
              ],
            ),

            CheckboxListTile(
              value: _linkToAgenda,
              onChanged: (v) => setState(() => _linkToAgenda = v!),
              title: const Text('Vincular à agenda'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              value: _notifyClient,
              onChanged: (v) => setState(() => _notifyClient = v!),
              title: const Text('Notificar cliente'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleCheckIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Fazer Check-in',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
