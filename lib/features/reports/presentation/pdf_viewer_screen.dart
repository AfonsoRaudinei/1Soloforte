import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';

/// Visualizador de PDF com pinch to zoom e controles avançados
class PdfViewerScreen extends StatefulWidget {
  final Uint8List pdfBytes;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.pdfBytes,
    required this.title,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  int _currentPage = 1;
  int _totalPages = 0;
  double _zoomLevel = 1.0;
  bool _showControls = true;

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: const BackButton(),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // PDF Viewer
          GestureDetector(
            onTap: () {
              setState(() => _showControls = !_showControls);
            },
            child: SfPdfViewer.memory(
              widget.pdfBytes,
              key: _pdfViewerKey,
              controller: _pdfViewerController,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                setState(() {
                  _totalPages = details.document.pages.count;
                });
              },
              onPageChanged: (PdfPageChangedDetails details) {
                setState(() {
                  _currentPage = details.newPageNumber;
                });
              },
              onZoomLevelChanged: (PdfZoomDetails details) {
                setState(() {
                  _zoomLevel = details.newZoomLevel;
                });
              },
              enableDoubleTapZooming: true,
              enableTextSelection: true,
              canShowScrollHead: true,
              canShowScrollStatus: true,
            ),
          ),

          // Título e controles superiores
          if (_showControls)
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_totalPages > 0)
                            Text(
                              'Página $_currentPage de $_totalPages',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        _pdfViewerKey.currentState?.openBookmarkView();
                      },
                      tooltip: 'Buscar',
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Compartilhar PDF')),
                        );
                      },
                      tooltip: 'Compartilhar',
                    ),
                    PopupMenuButton<String>(
                      iconColor: Colors.white,
                      onSelected: _handleMenuAction,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'fit_width',
                          child: Row(
                            children: [
                              Icon(Icons.fit_screen, size: 20),
                              SizedBox(width: 12),
                              Text('Ajustar à largura'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'fit_page',
                          child: Row(
                            children: [
                              Icon(Icons.fullscreen, size: 20),
                              SizedBox(width: 12),
                              Text('Ajustar à página'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'rotate',
                          child: Row(
                            children: [
                              Icon(Icons.rotate_right, size: 20),
                              SizedBox(width: 12),
                              Text('Rotacionar'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'print',
                          child: Row(
                            children: [
                              Icon(Icons.print, size: 20),
                              SizedBox(width: 12),
                              Text('Imprimir'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Controles inferiores
          if (_showControls) _buildBottomControls(),

          // Indicador de página
          if (_showControls) _buildPageIndicator(),

          // Controles de zoom
          if (_showControls) _buildZoomControls(),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black87, Colors.black54, Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              icon: Icons.first_page,
              onPressed: _currentPage > 1
                  ? () => _pdfViewerController.jumpToPage(1)
                  : null,
              tooltip: 'Primeira página',
            ),
            _buildControlButton(
              icon: Icons.chevron_left,
              onPressed: _currentPage > 1
                  ? () => _pdfViewerController.previousPage()
                  : null,
              tooltip: 'Página anterior',
            ),
            _buildPageSelector(),
            _buildControlButton(
              icon: Icons.chevron_right,
              onPressed: _currentPage < _totalPages
                  ? () => _pdfViewerController.nextPage()
                  : null,
              tooltip: 'Próxima página',
            ),
            _buildControlButton(
              icon: Icons.last_page,
              onPressed: _currentPage < _totalPages
                  ? () => _pdfViewerController.jumpToPage(_totalPages)
                  : null,
              tooltip: 'Última página',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
      tooltip: tooltip,
      iconSize: 28,
    );
  }

  Widget _buildPageSelector() {
    return GestureDetector(
      onTap: _showPageJumpDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$_currentPage / $_totalPages',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      top: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Página $_currentPage de $_totalPages',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      right: 16,
      top: 100,
      child: Column(
        children: [
          _buildZoomButton(
            icon: Icons.add,
            onPressed: () {
              _pdfViewerController.zoomLevel = _zoomLevel + 0.25;
            },
            tooltip: 'Aumentar zoom',
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${(_zoomLevel * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildZoomButton(
            icon: Icons.remove,
            onPressed: () {
              if (_zoomLevel > 0.5) {
                _pdfViewerController.zoomLevel = _zoomLevel - 0.25;
              }
            },
            tooltip: 'Diminuir zoom',
          ),
          const SizedBox(height: 8),
          _buildZoomButton(
            icon: Icons.refresh,
            onPressed: () {
              _pdfViewerController.zoomLevel = 1.0;
            },
            tooltip: 'Resetar zoom',
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        tooltip: tooltip,
        iconSize: 24,
      ),
    );
  }

  void _showPageJumpDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ir para página'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Digite o número da página (1-$_totalPages)',
            border: const OutlineInputBorder(),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final page = int.tryParse(controller.text);
              if (page != null && page >= 1 && page <= _totalPages) {
                _pdfViewerController.jumpToPage(page);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Digite um número entre 1 e $_totalPages'),
                  ),
                );
              }
            },
            child: const Text('Ir'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'fit_width':
        _pdfViewerController.zoomLevel = 1.5;
        break;
      case 'fit_page':
        _pdfViewerController.zoomLevel = 1.0;
        break;
      case 'rotate':
        // TODO: Implementar rotação
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rotação em desenvolvimento')),
        );
        break;
      case 'print':
        // TODO: Implementar impressão
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impressão em desenvolvimento')),
        );
        break;
    }
  }
}
