import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/support/data/chat_service.dart';
import 'package:soloforte_app/features/support/data/storage_service.dart';
import 'package:soloforte_app/features/support/domain/message_model.dart';
import 'package:soloforte_app/features/support/domain/ticket_model.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  final Ticket? ticket;
  const ChatScreen({super.key, this.ticket});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _chatService = ChatWebSocketService();
  final _storageService = StorageService();

  bool _isAgentTyping = false;
  bool _isAgentOnline = true;
  List<String> _quickReplies = [];

  @override
  void initState() {
    super.initState();
    _connectChat();
  }

  Future<void> _connectChat() async {
    _chatService.isTypingStream.listen((isTyping) {
      if (mounted) setState(() => _isAgentTyping = isTyping);
      if (isTyping) _scrollToBottom();
    });

    _chatService.isOnlineStream.listen((isOnline) {
      if (mounted) setState(() => _isAgentOnline = isOnline);
    });

    _chatService.quickRepliesStream.listen((replies) {
      if (mounted) setState(() => _quickReplies = replies);
      if (replies.isNotEmpty) _scrollToBottom();
    });

    _chatService.messagesStream.listen((_) {
      _scrollToBottom();
    });

    await _chatService.connect();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _chatService.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage({
    String? text,
    MessageType type = MessageType.text,
    String? attachmentUrl,
  }) {
    final msgText = text ?? _controller.text;
    if (msgText.trim().isEmpty && type == MessageType.text) return;

    _chatService.sendMessage(msgText, type: type, attachmentUrl: attachmentUrl);
    if (type == MessageType.text && text == null) _controller.clear();
  }

  Future<void> _showAttachmentMenu() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Anexar', style: AppTypography.h3),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _AttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Câmera',
                  color: Colors.purple,
                  onTap: () => _handleImageSelection(ImageSource.camera),
                ),
                _AttachmentOption(
                  icon: Icons.image,
                  label: 'Galeria',
                  color: Colors.blue,
                  onTap: () => _handleImageSelection(ImageSource.gallery),
                ),
                _AttachmentOption(
                  icon: Icons.description,
                  label: 'Documento',
                  color: Colors.orange,
                  onTap: _handleFileSelection,
                ),
                _AttachmentOption(
                  icon: Icons.location_on,
                  label: 'Localização',
                  color: Colors.green,
                  onTap: _handleLocationSelection,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _handleImageSelection(ImageSource source) async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final url = await _storageService.uploadFile(
        File(pickedFile.path),
        'images',
      );
      _sendMessage(
        text: 'Imagem enviada',
        type: MessageType.image,
        attachmentUrl: url,
      );
    }
  }

  Future<void> _handleFileSelection() async {
    Navigator.pop(context);
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final url = await _storageService.uploadFile(file, 'docs');
      _sendMessage(
        text: result.files.single.name,
        type: MessageType.file,
        attachmentUrl: url,
      );
    }
  }

  void _handleLocationSelection() {
    Navigator.pop(context);
    _sendMessage(
      text: 'Minha localização atual',
      type: MessageType.location,
      attachmentUrl: '-23.550520,-46.633308',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  child: Text('🤖', style: TextStyle(fontSize: 20)),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Suporte SoloForte',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: _isAgentOnline ? Colors.green : Colors.grey,
                      size: 8,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isAgentOnline ? 'Online' : 'Offline',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.messagesStream,
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + 1, // +1 for date header mocked
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Hoje, 10:45',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      );
                    }
                    final msg = messages[index - 1]; // shift index
                    return _buildMessage(msg);
                  },
                );
              },
            ),
          ),

          // Typing indicator
          if (_isAgentTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    child: Text('🤖', style: TextStyle(fontSize: 10)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Agente digitando...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          if (_quickReplies.isNotEmpty)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _quickReplies
                    .map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          label: Text(r),
                          onPressed: () => _sendMessage(text: r),
                          backgroundColor: Colors.blue[50],
                          labelStyle: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

          // Custom Input Area
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _showAttachmentMenu,
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                ),
                IconButton(
                  onPressed: () => _handleImageSelection(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt, color: Colors.grey),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Digite...',
                      ),
                      onSubmitted: (val) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: () => _sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message msg) {
    if (msg.isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(msg.text, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 4),
                  const Text(
                    '10:46',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey,
              child: Text('🤖', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 8),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(msg.text, style: const TextStyle(color: Colors.black87)),
                  if (msg.text.contains('Resolvido')) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Resolver Ticket'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                        backgroundColor: Colors.green[50],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  const Text(
                    '10:47',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}
