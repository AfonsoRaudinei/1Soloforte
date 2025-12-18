import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/stamps/ndvi_chart_stamp.dart';

class ImageEditorScreen extends StatefulWidget {
  final XFile imageFile;

  const ImageEditorScreen({super.key, required this.imageFile});

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  final GlobalKey _globalKey = GlobalKey();
  String _activeTool = 'Filtros';

  // Adjustments
  double _brightness = 0.0;
  double _contrast = 1.0;
  double _saturation = 1.0;

  // Filter
  List<double> _currentFilter = _noFilter;

  // Overlays
  List<EditorLayer> _layers = [];
  bool _showWatermark = false;
  bool _showLogo = false;

  // Crop (Mocked for visual only as complex cropping requires packages/native)
  bool _isCropping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white), // [×]
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
        title: const Text('Editar Foto', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton.icon(
            onPressed: _saveImage,
            icon: const Icon(Icons.check, color: AppColors.primary),
            label: const Text(
              'Salvar',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Canvas Area
          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: _globalKey,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 500),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Base Image with Filters & Adjustments
                      ColorFiltered(
                        colorFilter: ColorFilter.matrix(
                          _calculateContrastMatrix(_contrast),
                        ),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.matrix(
                            _calculateSaturationMatrix(_saturation),
                          ),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.matrix(
                              _calculateBrightnessMatrix(_brightness),
                            ),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.matrix(_currentFilter),
                              child: Image.file(
                                File(widget.imageFile.path),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Layers (Text, Stickers)
                      ..._layers
                          .map((layer) => _buildLayerWidget(layer))
                          .toList(),

                      // Watermark
                      if (_showWatermark)
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            color: Colors.black54,
                            child: const Text(
                              'SoloForte',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      if (_showLogo)
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Icon(
                            Icons.agriculture,
                            size: 40,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),

                      // Crop Overlay
                      if (_isCropping)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              color: Colors.black54.withOpacity(0.5),
                            ),
                            child: Center(
                              child: Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                  color:
                                      Colors.transparent, // Cutout simulation
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Toolbar Icons
          Container(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            color: Colors.grey[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToolIcon(Icons.palette, 'Filtros'), // [🎨]
                _buildToolIcon(Icons.crop, 'Crop'), // [✂️]
                _buildToolIcon(Icons.text_fields, 'Texto'), // [📝]
                _buildToolIcon(Icons.tune, 'Ajustes'), // [🔧]
                _buildToolIcon(Icons.auto_fix_high, 'Magia'), // [✨]
              ],
            ),
          ),

          // Detailed Controls
          Container(
            height: 160,
            color: Colors.black,
            padding: EdgeInsets.all(AppSpacing.md),
            child: _buildControlPanel(),
          ),

          // Bottom Actions
          Container(
            color: Colors.black,
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: _layers.isNotEmpty
                      ? () => setState(() => _layers.removeLast())
                      : null,
                  icon: const Icon(Icons.undo, color: Colors.white70, size: 20),
                  label: const Text(
                    'Desfazer',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                TextButton.icon(
                  onPressed: null, // Placeholder for Redo
                  icon: const Icon(Icons.redo, color: Colors.white30, size: 20),
                  label: const Text(
                    'Refazer',
                    style: TextStyle(color: Colors.white30),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() {
                    _brightness = 0;
                    _contrast = 1;
                    _saturation = 1;
                    _currentFilter = _noFilter;
                    _layers.clear();
                  }),
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  label: const Text(
                    'Resetar',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    switch (_activeTool) {
      case 'Filtros':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filtros', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _filterButton('Normal', _noFilter),
                  _filterButton('Vivid', _vividFilter),
                  _filterButton('P&B', _bwFilter),
                  _filterButton('Sépia', _sepiaFilter),
                  _filterButton('Invert', _invertFilter),
                ],
              ),
            ),
          ],
        );
      case 'Ajustes': // [🔧]
        return Column(
          children: [
            _sliderRow(
              'Brilho',
              _brightness,
              -1.0,
              1.0,
              (v) => _brightness = v,
            ),
            _sliderRow('Contraste', _contrast, 0.0, 3.0, (v) => _contrast = v),
            _sliderRow(
              'Saturação',
              _saturation,
              0.0,
              3.0,
              (v) => _saturation = v,
            ),
            // Watermark toggle moved here or under Magic? ASCII puts watermark as tool or detailed control.
            // Let's add it here for utility.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Marca d\'água',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Switch(
                  value: _showWatermark,
                  onChanged: (v) => setState(() => _showWatermark = v),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ],
        );
      case 'Crop':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ajuste o enquadramento',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _isCropping = !_isCropping),
                  child: Text(_isCropping ? 'Aplicar' : 'Ativar Recorte'),
                ),
              ],
            ),
          ],
        );
      case 'Texto':
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Adicionar Texto',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addTextLayer,
                icon: const Icon(Icons.add),
                label: const Text('Novo Texto'),
              ),
            ],
          ),
        );
      case 'Magia': // [✨]
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Templates SoloForte:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _templatePreviewButton('1', Colors.green),
                  _templatePreviewButton('2', Colors.blue),
                  _templatePreviewButton('3', Colors.orange),
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.apps, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ver +',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    color: Colors.grey,
                    indent: 10,
                    endIndent: 10,
                  ),
                  // Re-add Stickers/Data access here
                  _stickerButton('🚜'),
                  _stickerButton('📍'),
                  _dataButton('NDVI', const NdviChartStamp()),
                ],
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _templatePreviewButton(String label, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Template',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helpers ---

  Future<void> _saveImage() async {
    try {
      RenderRepaintBoundary? boundary =
          _globalKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary != null) {
        // ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        // ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        // Uint8List pngBytes = byteData!.buffer.asUint8List();

        // Here we would perform the save logic, likely writing to a temp file and passing back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagem salva (simulação)')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error saving image: $e");
    }
  }

  void _addTextLayer() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inserir Texto'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Digite aqui...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _layers.add(
                    EditorLayer(
                      type: LayerType.text,
                      content: controller.text,
                      position: const Offset(0, 0),
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  Widget _buildLayerWidget(EditorLayer layer) {
    return Positioned(
      left: layer.position.dx == 0 && layer.position.dy == 0
          ? null
          : layer.position.dx,
      top: layer.position.dx == 0 && layer.position.dy == 0
          ? null
          : layer.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            double currentX = layer.position.dx == 0
                ? MediaQuery.of(context).size.width / 2
                : layer.position.dx;
            double currentY = layer.position.dy == 0
                ? MediaQuery.of(context).size.height / 2
                : layer.position.dy;

            layer.position = Offset(
              currentX + details.delta.dx,
              currentY + details.delta.dy,
            );
          });
        },
        child: _buildLayerContent(layer),
      ),
    );
  }

  Widget _buildLayerContent(EditorLayer layer) {
    switch (layer.type) {
      case LayerType.text:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Text(
            layer.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case LayerType.sticker:
        return Container(
          padding: const EdgeInsets.all(4),
          child: Text(layer.content, style: const TextStyle(fontSize: 40)),
        );
      case LayerType.widget:
        return layer.widget ?? const SizedBox();
    }
  }

  // --- UI Components ---

  Widget _buildToolIcon(IconData icon, String label) {
    final isActive = _activeTool == label;
    return GestureDetector(
      onTap: () => setState(() => _activeTool = label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? AppColors.primary : Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.primary : Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(String name, List<double> filter) {
    return GestureDetector(
      onTap: () => setState(() => _currentFilter = filter),
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: borderForFilter(filter),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(filter),
                  child: Image.file(
                    File(widget.imageFile.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  BoxBorder? borderForFilter(List<double> filter) {
    return _currentFilter == filter
        ? Border.all(color: AppColors.primary, width: 2)
        : null;
  }

  Widget _stickerButton(String emoji) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _layers.add(
            EditorLayer(
              type: LayerType.sticker,
              content: emoji,
              position: const Offset(100, 100),
            ),
          );
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _dataButton(String label, Widget widget) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _layers.add(
            EditorLayer(
              type: LayerType.widget,
              content: label,
              position: const Offset(100, 100),
              widget: widget,
            ),
          );
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(Icons.widgets, color: Colors.white),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliderRow(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: (v) => setState(() {
              onChanged(v);
            }),
            activeColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  // --- Logic ---

  List<double> _calculateBrightnessMatrix(double brightness) {
    // Brightness is an offset: value * 255 typically used, but here simpler
    final b = brightness * 100;
    return [1, 0, 0, 0, b, 0, 1, 0, 0, b, 0, 0, 1, 0, b, 0, 0, 0, 1, 0];
  }

  List<double> _calculateContrastMatrix(double contrast) {
    final t = (1.0 - contrast) / 2.0 * 255.0;
    return [
      contrast,
      0,
      0,
      0,
      t,
      0,
      contrast,
      0,
      0,
      t,
      0,
      0,
      contrast,
      0,
      t,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  List<double> _calculateSaturationMatrix(double saturation) {
    final s = saturation;
    final invS = 1 - s;
    final R = 0.2126 * invS;
    final G = 0.7152 * invS;
    final B = 0.0722 * invS;

    return [
      R + s,
      G,
      B,
      0,
      0,
      R,
      G + s,
      B,
      0,
      0,
      R,
      G,
      B + s,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  // Matrix Presets
  static const List<double> _noFilter = [
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];

  static const List<double> _bwFilter = [
    0.33,
    0.33,
    0.33,
    0.0,
    0,
    0.33,
    0.33,
    0.33,
    0.0,
    0,
    0.33,
    0.33,
    0.33,
    0.0,
    0,
    0.0,
    0.0,
    0.0,
    1.0,
    0,
  ];

  static const List<double> _sepiaFilter = [
    0.393,
    0.769,
    0.189,
    0,
    0,
    0.349,
    0.686,
    0.168,
    0,
    0,
    0.272,
    0.534,
    0.131,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];

  static const List<double> _invertFilter = [
    -1,
    0,
    0,
    0,
    255,
    0,
    -1,
    0,
    0,
    255,
    0,
    0,
    -1,
    0,
    255,
    0,
    0,
    0,
    1,
    0,
  ];

  static const List<double> _vividFilter = [
    1.2,
    0,
    0,
    0,
    0,
    0,
    1.2,
    0,
    0,
    0,
    0,
    0,
    1.2,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];
}

// --- Types ---

enum LayerType { text, sticker, widget }

class EditorLayer {
  final LayerType type;
  final String content;
  final Widget? widget; // For complex widgets like charts
  Offset position;
  double scale;
  double rotation;

  EditorLayer({
    required this.type,
    required this.content,
    required this.position,
    this.widget,
    this.scale = 1.0,
    this.rotation = 0.0,
  });
}
