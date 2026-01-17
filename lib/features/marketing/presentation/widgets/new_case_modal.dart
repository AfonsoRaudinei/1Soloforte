import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class NewCaseSuccessModal extends StatefulWidget {
  final double latitude;
  final double longitude;

  const NewCaseSuccessModal({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<NewCaseSuccessModal> createState() => _NewCaseSuccessModalState();
}

class _NewCaseSuccessModalState extends State<NewCaseSuccessModal> {
  // Form State
  String _selectedType = 'antes-depois';
  String _selectedSize = 'prata';
  String _unit = 'sc/ha';
  String? _imagePath;

  final _producerController = TextEditingController();
  final _locationController = TextEditingController();
  final _productController = TextEditingController();
  final _productivityController = TextEditingController();
  final _gainController = TextEditingController();
  final _savingsController = TextEditingController();
  final _sellerController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Colors from CSS
  static const Color kSfDark = Color(0xFF1E3A2F);
  static const Color kSfDarkDeep = Color(0xFF0F2417);
  static const Color kSfGreen = Color(0xFF4ADE80);
  static const Color kSfGreenDark = Color(0xFF22C55E);
  static const Color kGray100 = Color(0xFFF5F5F7);
  static const Color kGray300 = Color(0xFFD1D5DB);
  static const Color kGray900 = Color(0xFF1D1D1F);

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _imagePath = result.files.single.path;
      });
    }
  }

  void _submit() {
    // Validate
    if (_producerController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _productController.text.isEmpty ||
        _sellerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Preencha os campos obrigatórios')),
      );
      return;
    }

    // O tipo 'type' deve ser exatamente 'antes-depois' ou 'resultado'
    // para diferenciar visualmente no mapa
    final caseData = {
      'type': _selectedType, // 'antes-depois' ou 'resultado'
      'size': _selectedSize, // 'bronze', 'prata', ou 'ouro'
      'producer': _producerController.text,
      'location': _locationController.text,
      'product': _productController.text,
      'productivity': '${_productivityController.text} $_unit',
      'gain': _gainController.text,
      'savings': _savingsController.text,
      'seller': _sellerController.text,
      'phone': _phoneController.text,
      'company': _companyController.text,
      'description': _descriptionController.text,
      'image': _imagePath,
      'latitude': widget.latitude,
      'longitude': widget.longitude,
    };

    Navigator.pop(context, caseData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Case publicado com sucesso!'),
        backgroundColor: kSfDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Subtítulo dinâmico baseado na aba ativa
    final String subtitle = _selectedType == 'antes-depois'
        ? 'Antes e Depois'
        : 'Resultado';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 800),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 60,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header com Tabs Integradas
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kSfDark, kSfDarkDeep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Título e botão fechar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Novo Case de Sucesso',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: kSfGreen,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  // Tabs no Header
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _buildHeaderTab('Antes e Depois', 'antes-depois'),
                        _buildHeaderTab('Resultado', 'resultado'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Investment Level
                  _buildLabel('Nível de investimento em marketing'),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: kGray100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _buildSegmentOption('Bronze', 'bronze'),
                        _buildSegmentOption('Prata', 'prata'),
                        _buildSegmentOption('Ouro', 'ouro'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Fields
                  _buildTextField(
                    'Producer/Farm',
                    _producerController,
                    placeholder: 'Ex: Fazenda Santa Rita',
                  ),
                  _buildTextField(
                    'Location',
                    _locationController,
                    placeholder: 'Ex: Jataizinho - PR',
                  ),

                  // Product
                  _buildTextField(
                    'Product',
                    _productController,
                    placeholder: 'Ex: Soja Olímpo',
                  ),

                  // Productivity Row
                  _buildLabel('Productivity'),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(
                          controller: _productivityController,
                          placeholder: '80',
                          type: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: kGray300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _unit,
                            items: const [
                              DropdownMenuItem(
                                value: 'sc/ha',
                                child: Text('sc/ha'),
                              ),
                              DropdownMenuItem(
                                value: 'ton/ha',
                                child: Text('ton/ha'),
                              ),
                              DropdownMenuItem(
                                value: 'kg/ha',
                                child: Text('kg/ha'),
                              ),
                            ],
                            onChanged: (v) => setState(() => _unit = v!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Gain & Savings
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Ganho (%)'),
                            _buildInput(
                              controller: _gainController,
                              placeholder: '+38%',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Economia'),
                            _buildInput(
                              controller: _savingsController,
                              placeholder: 'R\$ 22.000',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Photo Upload
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: kGray100,
                        border: Border.all(
                          color: kGray300,
                          style: BorderStyle.solid,
                        ), // Dashed border needs a package or custom painter, solid for now
                        borderRadius: BorderRadius.circular(12),
                        image: _imagePath != null
                            ? DecorationImage(
                                image: FileImage(File(_imagePath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _imagePath == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 32,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Clique para adicionar foto',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => _imagePath = null),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      radius: 12,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    'Seller Name',
                    _sellerController,
                    placeholder: 'Ex: Carlos Silva',
                  ),
                  _buildTextField(
                    'Phone',
                    _phoneController,
                    placeholder: '(43) 99876-5432',
                    type: TextInputType.phone,
                  ),
                  _buildTextField(
                    'Company',
                    _companyController,
                    placeholder: 'Ex: AgroTech Solutions',
                  ),

                  const SizedBox(height: 20),
                  _buildLabel('Description'),
                  _buildInput(
                    controller: _descriptionController,
                    placeholder: 'Descreva brevemente o caso...',
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: kSfGreen.withValues(alpha: 0.6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: kSfGreenDark,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: kSfGreen.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Publish',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: kGray900,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          children: [
            if (required)
              const TextSpan(
                text: ' ●',
                style: TextStyle(color: kSfGreenDark),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? placeholder,
    TextInputType? type,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          _buildInput(
            controller: controller,
            placeholder: placeholder,
            type: type,
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    String? placeholder,
    TextInputType? type,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: kGray900),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kGray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kSfGreen, width: 2),
        ),
      ),
    );
  }

  /// Tab estilizada para o header do modal (fundo escuro)
  Widget _buildHeaderTab(String label, String value) {
    final isActive = _selectedType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white60,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentOption(String label, String value) {
    final isActive = _selectedSize == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSize = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? kGray900 : Colors.grey[600],
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
