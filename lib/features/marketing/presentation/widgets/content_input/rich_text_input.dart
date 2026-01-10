import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

class RichTextInput extends StatefulWidget {
  final TextEditingController controller;
  final int maxLength;
  final ValueChanged<String>? onChanged;

  const RichTextInput({
    super.key,
    required this.controller,
    this.maxLength = 500,
    this.onChanged,
  });

  @override
  State<RichTextInput> createState() => _RichTextInputState();
}

class _RichTextInputState extends State<RichTextInput> {
  final List<String> _suggestedHashtags = [
    '#soja',
    '#milho',
    '#colheita',
    '#agro',
    '#soloforte',
    '#produtividade',
  ];
  List<String> _filteredHashtags = [];
  bool _showHashtagSuggestions = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.controller.text;
    final selection = widget.controller.selection;

    if (selection.baseOffset >= 0) {
      final currentWord = _getCurrentWord(text, selection.baseOffset);
      if (currentWord.startsWith('#')) {
        setState(() {
          _filteredHashtags = _suggestedHashtags
              .where(
                (tag) => tag.toLowerCase().contains(currentWord.toLowerCase()),
              )
              .toList();
          _showHashtagSuggestions = _filteredHashtags.isNotEmpty;
        });
      } else {
        if (_showHashtagSuggestions) {
          setState(() {
            _showHashtagSuggestions = false;
          });
        }
      }
    }
  }

  String _getCurrentWord(String text, int cursorPosition) {
    if (text.isEmpty) return '';
    int start = cursorPosition;
    int end = cursorPosition;

    // Move start backwards to find word beginning
    while (start > 0 && text[start - 1] != ' ' && text[start - 1] != '\n') {
      start--;
    }
    // Move end forwards
    while (end < text.length && text[end] != ' ' && text[end] != '\n') {
      end++;
    }

    if (start >= end) return '';
    return text.substring(start, end);
  }

  void _insertHashtag(String tag) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;
    final currentOffset = selection.baseOffset;

    // Find prompt start
    int start = currentOffset;
    while (start > 0 && text[start - 1] != ' ' && text[start - 1] != '\n') {
      start--;
    }

    // Find prompt end
    int end = currentOffset;
    while (end < text.length && text[end] != ' ' && text[end] != '\n') {
      end++;
    }

    final newText = text.replaceRange(start, end, '$tag ');
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + tag.length + 1),
    );

    setState(() => _showHashtagSuggestions = false);
  }

  void _addEmoji(String emoji) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;

    final newText = text.replaceRange(start, end, emoji);
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            TextField(
              controller: widget.controller,
              maxLength: widget.maxLength,
              maxLines: 5,
              onChanged: widget.onChanged,
              buildCounter:
                  (
                    context, {
                    required currentLength,
                    required isFocused,
                    maxLength,
                  }) {
                    return null; // Hide default counter to use custom
                  },
              decoration: InputDecoration(
                hintText: 'Escreva sua legenda...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
            if (_showHashtagSuggestions)
              Positioned(
                left: 0,
                right: 0,
                bottom:
                    0, // Above keyboard theoretically but relative to input here
                child: Container(
                  height: 40,
                  color: AppColors.backgroundSecondary,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filteredHashtags.length,
                    itemBuilder: (context, index) {
                      final tag = _filteredHashtags[index];
                      return GestureDetector(
                        onTap: () => _insertHashtag(tag),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: AppSpacing.xs),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Formatting & Emojis
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  onPressed: () {
                    // Quick emoji picker
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SizedBox(
                        height: 200,
                        child: GridView.count(
                          crossAxisCount: 8,
                          padding: const EdgeInsets.all(16),
                          children:
                              [
                                    '🚜',
                                    '🌾',
                                    '🌽',
                                    '🌱',
                                    '🌧️',
                                    '🌞',
                                    '📈',
                                    '💪',
                                    '🔥',
                                    '✅',
                                    '⚠️',
                                    '📊',
                                    '🐂',
                                    '💰',
                                    '🇧🇷',
                                    '🤠',
                                  ]
                                  .map(
                                    (e) => GestureDetector(
                                      onTap: () {
                                        _addEmoji(e);
                                        Navigator.pop(context);
                                      },
                                      child: Center(
                                        child: Text(
                                          e,
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.tag),
                  onPressed: () {
                    // Add #
                    _addEmoji('#');
                  },
                ),
              ],
            ),

            // Character Counter
            ValueListenableBuilder(
              valueListenable: widget.controller,
              builder: (context, TextEditingValue value, child) {
                final length = value.text.length;
                return Text(
                  '$length / ${widget.maxLength}',
                  style: AppTypography.caption.copyWith(
                    color: length > widget.maxLength
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
