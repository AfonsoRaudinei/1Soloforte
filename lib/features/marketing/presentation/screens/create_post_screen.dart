import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/marketing/presentation/widgets/create_post/templates_section.dart';
import 'package:soloforte_app/features/marketing/domain/post_model.dart';
import 'package:soloforte_app/features/marketing/data/marketing_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class CreatePostScreen extends StatefulWidget {
  final Post? draft;
  const CreatePostScreen({super.key, this.draft});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final MarketingRepository _repository = MarketingRepository();

  // Publish Targets
  bool _publishToFeed = true;
  bool _publishToInstagram = true;
  bool _publishToFacebook = true;
  bool _publishToLinkedIn = false;
  bool _publishToTwitter = false;

  // Scheduling
  bool _isScheduled = false; // false = Publicar agora, true = Agendar
  DateTime _scheduledDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _scheduledTime = const TimeOfDay(hour: 14, minute: 0);

  @override
  void initState() {
    super.initState();
    if (widget.draft != null) {
      _textController.text = widget.draft!.content;
      // In a real app we would download images here to populate _selectedImages
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_selectedImages.length >= 10) return;
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close), // [×]
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Nova Publicação'),
        actions: [
          IconButton(
            icon: const Icon(Icons.paste), // [📋]
            onPressed: () {
              // Drafts functionality placeholder
            },
            tooltip: 'Rascunhos',
          ),
          IconButton(
            icon: const Icon(Icons.check), // [✓]
            onPressed: _handlePublish,
            tooltip: 'Concluir',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Image Picker Area
            _buildImagePickerArea(),
            const SizedBox(height: 8),
            const Text(
              'Até 10 fotos',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.right,
            ),

            SizedBox(height: AppSpacing.lg),

            // 2. Templates
            const Text(
              'Templates Sugeridos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const TemplatesSection(), // Reusing existing widget as it matches well enough or can be updated separately
            SizedBox(height: AppSpacing.lg),

            // 3. Text Input
            const Text(
              'Escreva sua mensagem',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Compartilhe seus resultados...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            SizedBox(height: AppSpacing.md),

            // 4. Data Integration
            _buildDataIntegrationSection(),
            SizedBox(height: AppSpacing.lg),

            // 5. Publish Targets
            const Text(
              'Publicar em:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              value: _publishToFeed,
              onChanged: (v) => setState(() => _publishToFeed = v!),
              title: const Text('Feed SoloForte'),
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              value: _publishToInstagram,
              onChanged: (v) => setState(() => _publishToInstagram = v!),
              title: const Text('Instagram'),
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              value: _publishToFacebook,
              onChanged: (v) => setState(() => _publishToFacebook = v!),
              title: const Text('Facebook'),
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              value: _publishToLinkedIn,
              onChanged: (v) => setState(() => _publishToLinkedIn = v!),
              title: const Text('LinkedIn'),
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              value: _publishToTwitter,
              onChanged: (v) => setState(() => _publishToTwitter = v!),
              title: const Text('Twitter'),
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),

            SizedBox(height: AppSpacing.lg),

            // 6. Scheduling
            const Text(
              'Agendar Publicação',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RadioListTile<bool>(
              value: false,
              groupValue: _isScheduled,
              onChanged: (v) => setState(() => _isScheduled = v!),
              title: const Text('Publicar agora'),
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<bool>(
              value: true,
              groupValue: _isScheduled,
              onChanged: (v) => setState(() => _isScheduled = v!),
              title: const Text('Agendar para:'),
              contentPadding: EdgeInsets.zero,
            ),

            if (_isScheduled)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _scheduledDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (d != null) setState(() => _scheduledDate = d);
                      },
                      child: Text(
                        DateFormat('dd/MMM/yyyy').format(_scheduledDate),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () async {
                        final t = await showTimePicker(
                          context: context,
                          initialTime: _scheduledTime,
                        );
                        if (t != null) setState(() => _scheduledTime = t);
                      },
                      child: Text(_scheduledTime.format(context)),
                    ),
                  ],
                ),
              ),

            SizedBox(height: AppSpacing.xl),

            // 7. Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saveDraft,
                    child: const Text('Salvar Rascunho'),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handlePublish,
                    child: const Text('Publicar'),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerArea() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _selectedImages.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                const SizedBox(height: 8),
                const Text(
                  'Toque para adicionar\nfoto ou vídeo',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library, size: 16),
                      label: const Text('Galeria'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt, size: 16),
                      label: const Text('Câmera'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: _selectedImages.length + 1,
              itemBuilder: (context, index) {
                if (index == _selectedImages.length) {
                  return Center(
                    child: IconButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(
                        Icons.add_circle,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                  );
                }
                final image = _selectedImages[index];
                return Stack(
                  children: [
                    Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 8),
                      child: Image.network(
                        image.path,
                        fit: BoxFit.cover,
                      ), // Assuming web/file path compatibility
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: InkWell(
                        onTap: () => _removeImage(index),
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildDataIntegrationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adicionar Dados (opcional)',
          style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              avatar: const Icon(Icons.bar_chart, size: 16),
              label: const Text('Incluir gráfico NDVI'),
              onPressed: () {},
            ),
            ActionChip(
              avatar: const Icon(Icons.location_on, size: 16),
              label: const Text('Marcar localização'),
              onPressed: () {},
            ),
            ActionChip(
              avatar: const Icon(Icons.person, size: 16),
              label: const Text('Marcar produtor'),
              onPressed: () {},
            ),
            ActionChip(
              avatar: const Icon(Icons.tag, size: 16),
              label: const Text('Adicionar hashtags'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _saveDraft() async {
    // ... existing logic ...
    final draftPost = Post(
      id: widget.draft?.id ?? const Uuid().v4(),
      title: 'Rascunho',
      content: _textController.text,
      createdAt: DateTime.now(),
      authorId: 'user_123',
      authorName: 'Produtor Demo',
      imageUrls: _selectedImages.map((e) => e.path).toList(),
      status: PostStatus.draft,
      scheduledTo: null,
    );

    await _repository.savePost(draftPost);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rascunho salvo com sucesso!')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _handlePublish() async {
    // ... existing logic ...
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Publicação enviada!')));
    Navigator.pop(context);
  }
}
