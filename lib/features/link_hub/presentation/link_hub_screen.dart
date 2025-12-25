import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LinkHubScreen extends StatefulWidget {
  const LinkHubScreen({super.key});

  @override
  State<LinkHubScreen> createState() => _LinkHubScreenState();
}

class _LinkHubScreenState extends State<LinkHubScreen> {
  // Colors
  static const Color kIosBlue = Color(0xFF007AFF);
  static const Color kIosBlueDark = Color(0xFF0051D5);
  static const Color kWhite = Color(0xFFFFFFFF);
  static const Color kGreyLight = Color(0xFFF5F5F7);
  static const Color kTextMain = Color(0xFF1D1D1F);
  static const Color kTextSec = Color(0xFF86868B);
  static const Color kBorder = Color(0xFFD1D1D6);

  // Stats
  final List<String> _options = ['Opção A', 'Opção B', 'Opção C'];
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kGreyLight, Color(0xFFE5E5E7)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildGlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PREFERÊNCIAS', style: _sectionTitleStyle),
                              const SizedBox(height: 16),
                              _buildCompactDropdown(
                                hint: 'Selecione o Modo',
                                value: _selectedOption,
                                items: _options,
                                onChanged: (val) =>
                                    setState(() => _selectedOption = val),
                              ),
                              const SizedBox(height: 12),
                              _buildNumberInput(
                                label: 'Código (Max 7)',
                                maxLength: 7,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildGlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('AÇÕES RÁPIDAS', style: _sectionTitleStyle),
                              const SizedBox(height: 16),
                              _buildPrimaryButton(
                                label: 'Novo Relatório',
                                onTap: () {},
                              ),
                              const SizedBox(height: 12),
                              _buildSecondaryButton(
                                label: 'Visualizar Dados',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildUploadArea(),
                        // Space for floating button
                        const SizedBox(height: 120),
                      ]),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 30,
                right: 30,
                child: _buildFloatingPrintButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: kWhite,
          child: Icon(Icons.person, size: 40, color: kTextSec),
        ),
        const SizedBox(height: 16),
        const Text(
          'Painel Linkren',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: kTextMain,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gerencie suas preferências e acessos.',
          style: TextStyle(fontSize: 15, color: kTextSec),
        ),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kWhite.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, 1),
                blurRadius: 3,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildCompactDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: kWhite,
        border: Border.all(color: kBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(color: kTextSec, fontSize: 15),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: kTextSec),
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: const TextStyle(color: kTextMain, fontSize: 15),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildNumberInput({required String label, required int maxLength}) {
    return TextField(
      keyboardType: TextInputType.number,
      maxLength: maxLength,
      style: const TextStyle(fontSize: 15, color: kTextMain),
      decoration: InputDecoration(
        labelText: label,
        counterText: "", // Hide default counter
        labelStyle: const TextStyle(color: kTextSec),
        filled: true,
        fillColor: kWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: kIosBlue,
            width: 2,
          ), // iOS Focus Ring approximation
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kIosBlue, kIosBlueDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: kIosBlue.withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E5E7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: kTextSec,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingPrintButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [kIosBlue, kIosBlueDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: kIosBlue.withValues(alpha: 0.4),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: const Icon(Icons.print, color: Colors.white, size: 28),
    );
  }

  Widget _buildUploadArea() {
    return _buildGlassCard(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kGreyLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: kBorder,
                style: BorderStyle.solid,
                // Dashed border is complex in Flutter without packages, sticking to solid or simple custom paint.
                // Using solid for now as simple fallback or could use a package if available.
                // Actually, let's just make it look like a dropzone.
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.camera_alt, size: 32, color: kTextSec),
                const SizedBox(height: 8),
                Text(
                  'Upload de Fotos',
                  style: TextStyle(color: kTextSec, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get _sectionTitleStyle => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: kTextSec,
    letterSpacing: 0.5,
  );
}
