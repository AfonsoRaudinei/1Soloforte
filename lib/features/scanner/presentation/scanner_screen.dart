import 'dart:async';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/features/scanner/presentation/scanner_controller.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription> _cameras = [];

  // Camera State
  bool _isCameraInitialized = false;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentZoomLevel = 1.0;
  double _baseZoom = 1.0; // Added for pinch-to-zoom
  FlashMode _currentFlashMode = FlashMode.off;
  bool _isGridVisible = true;
  Offset? _focusPoint;

  // Analysis State
  String _currentTip = "Posicione a folha dentro da grade";
  Timer? _tipTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
    _startTipRotation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _tipTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) return;

      // Select the first rear camera
      final camera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;

      // Get Zoom levels
      _minAvailableZoom = await _controller!.getMinZoomLevel();
      _maxAvailableZoom = await _controller!.getMaxZoomLevel();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  void _startTipRotation() {
    final tips = [
      "Mantenha a câmera estável para melhor foco",
      "Certifique-se de que há boa iluminação",
      "Aproxime-se para capturar detalhes da praga",
      "Evite sombras diretas sobre a folha",
    ];
    int index = 0;
    _tipTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentTip = tips[index % tips.length];
          index++;
        });
      }
    });
  }

  Future<void> _setZoom(double zoom) async {
    if (_controller == null || !_isCameraInitialized) return;

    final zoomLevel = zoom.clamp(_minAvailableZoom, _maxAvailableZoom);
    await _controller!.setZoomLevel(zoomLevel);

    setState(() {
      _currentZoomLevel = zoomLevel;
    });
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_isCameraInitialized) return;

    FlashMode newMode;
    switch (_currentFlashMode) {
      case FlashMode.off:
        newMode = FlashMode.torch;
        break;
      case FlashMode.torch:
        newMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        newMode = FlashMode.off;
        break;
      default:
        newMode = FlashMode.off;
    }

    await _controller!.setFlashMode(newMode);
    setState(() {
      _currentFlashMode = newMode;
    });
  }

  Future<void> _onTapToFocus(TapUpDetails details) async {
    if (_controller == null || !_isCameraInitialized) return;

    final offset = Offset(
      details.localPosition.dx / MediaQuery.of(context).size.width,
      details.localPosition.dy / MediaQuery.of(context).size.height,
    );

    try {
      await _controller!.setExposurePoint(offset);
      await _controller!.setFocusPoint(offset);

      setState(() {
        _focusPoint = details.localPosition;
      });

      // Hide focus indicator after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _focusPoint = null;
          });
        }
      });
    } catch (e) {
      // Ignore focus errors on some devices
    }
  }

  void _takePhoto() async {
    final scannerState = ref.read(scannerControllerProvider);
    if (_controller == null ||
        !_isCameraInitialized ||
        scannerState.isAnalyzing) {
      return;
    }

    try {
      final image = await _controller!.takePicture();
      // Start Analysis
      ref.read(scannerControllerProvider.notifier).analyzeImage(image.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao capturar foto')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes
    ref.listen<ScannerState>(scannerControllerProvider, (previous, next) {
      if (next.result != null && !next.isAnalyzing) {
        // Navigate to results
        context.push(
          '/dashboard/scanner/results',
          extra: {'imagePath': next.result!.imagePath, 'result': next.result!},
        );
        // Reset controller for next time
        ref.read(scannerControllerProvider.notifier).reset();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
    });

    final scannerState = ref.watch(scannerControllerProvider);

    if (!_isCameraInitialized || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Camera Preview
          GestureDetector(
            onScaleStart: (details) {
              _baseZoom = _currentZoomLevel;
            },
            onScaleUpdate: (details) async {
              // Calculate new zoom level
              double scale = _baseZoom * details.scale;
              // Clamp logic handled in _setZoom but we want smooth updates here
              if (scale < _minAvailableZoom) scale = _minAvailableZoom;
              if (scale > _maxAvailableZoom) scale = _maxAvailableZoom;
              if (scale > 5.0) scale = 5.0; // Arbitrary UI limit

              await _controller!.setZoomLevel(scale);
              setState(() {
                _currentZoomLevel = scale;
              });
            },
            onTapUp: _onTapToFocus,
            child: CameraPreview(_controller!),
          ),

          // 2. Grid Overlay
          if (_isGridVisible)
            IgnorePointer(
              child: CustomPaint(painter: GridPainter(), child: Container()),
            ),

          // 3. Focus Indicator
          if (_focusPoint != null)
            Positioned(
              left: _focusPoint!.dx - 24,
              top: _focusPoint!.dy - 24,
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 1.5, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, double scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                },
              ),
            ),

          // 4. Top Controls (Glassmorphism)
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _currentFlashMode == FlashMode.off
                                  ? Icons.flash_off
                                  : _currentFlashMode == FlashMode.torch
                                  ? Icons.highlight
                                  : Icons.flash_auto,
                              color: _currentFlashMode == FlashMode.off
                                  ? Colors.white
                                  : Colors.amber,
                            ),
                            onPressed: _toggleFlash,
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Icon(
                              Icons.grid_4x4,
                              color: _isGridVisible
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                            onPressed: () => setState(
                              () => _isGridVisible = !_isGridVisible,
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 5. Smart Tips Pill
          Positioned(
            bottom: 180,
            left: 0,
            right: 0,
            child: Center(
              child: scannerState.isAnalyzing
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              value: scannerState.progress > 0
                                  ? scannerState.progress
                                  : null,
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            scannerState.statusMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.tips_and_updates,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _currentTip,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),

          // 6. Bottom Controls (Zoom & Capture)
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Zoom Slider
                Row(
                  children: [
                    const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 12,
                          ),
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          value: _currentZoomLevel,
                          min: _minAvailableZoom,
                          max: 5.0, // Limit to 5x even if camera supports more
                          onChanged: (value) {
                            _setZoom(value);
                          },
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_currentZoomLevel.toStringAsFixed(1)}x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Capture Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Gallary Button (Mock)
                    IconButton(
                      icon: const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {},
                    ),
                    // Shutter Button
                    GestureDetector(
                      onTap: _takePhoto,
                      child: Container(
                        width: 84,
                        height: 84,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: scannerState.isAnalyzing
                              ? const SizedBox() // Spinner is now in the center pill
                              : const Icon(
                                  Icons.camera,
                                  color: AppColors.primary,
                                  size: 32,
                                ),
                        ),
                      ),
                    ),
                    // Flip Camera (Mock logic for now, or implement swap)
                    IconButton(
                      icon: const Icon(
                        Icons.flip_camera_ios,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        // TODO: Implement camera switch
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    // Vertical lines
    canvas.drawLine(
      Offset(size.width * 0.33, 0),
      Offset(size.width * 0.33, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.66, 0),
      Offset(size.width * 0.66, size.height),
      paint,
    );

    // Horizontal lines
    canvas.drawLine(
      Offset(0, size.height * 0.33),
      Offset(size.width, size.height * 0.33),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.66),
      Offset(size.width, size.height * 0.66),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
