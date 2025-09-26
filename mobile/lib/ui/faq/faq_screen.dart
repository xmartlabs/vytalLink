import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_template/ui/extensions/context_extensions.dart';

@RoutePage()
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  Future<List<_FaqItem>> _loadFaq() async {
    final md = await rootBundle.loadString('assets/faq.md');
    return _parseFaqMarkdown(md);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.localizations;
    final theme = context.theme;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.faq_screen_title),
        centerTitle: true,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: FutureBuilder<List<_FaqItem>>(
        future: _loadFaq(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? const <_FaqItem>[];
          if (items.isEmpty) {
            return Center(
              child: Text(
                loc.faq_empty_message,
                style: theme.textTheme.bodyMedium,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    loc.faq_screen_subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }
              final item = items[index - 1];
              return VytalLinkCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: _FaqTile(item: item),
              );
            },
          );
        },
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.item});

  final _FaqItem item;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.item.question,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
        if (_open) ...[
          const SizedBox(height: 12),
          _FaqAnswer(blocks: widget.item.blocks),
        ],
      ],
    );
  }
}

class _FaqAnswer extends StatelessWidget {
  const _FaqAnswer({required this.blocks});

  final List<_FaqBlock> blocks;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final block in blocks) ...[
          switch (block) {
            _FaqParagraph(:final text) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ),
            _FaqList(:final items, :final ordered) => Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < items.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                              child: Text(
                                ordered ? '${i + 1}.' : '•',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                items[i],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            _ => const SizedBox.shrink(),
          },
        ],
      ],
    );
  }
}

class _FaqItem {
  _FaqItem({required this.question, required this.blocks});

  final String question;
  final List<_FaqBlock> blocks;
}

abstract class _FaqBlock {}

class _FaqParagraph extends _FaqBlock {
  _FaqParagraph(this.text);

  final String text;
}

class _FaqList extends _FaqBlock {
  _FaqList({required this.items, this.ordered = false});

  final List<String> items;
  final bool ordered;
}

List<_FaqItem> _parseFaqMarkdown(String md) {
  final lines = md.split('\n');
  final items = <_FaqItem>[];
  String? currentQuestion;
  final currentAnswer = <String>[];

  void flushCurrent() {
    if (currentQuestion == null) return;
    final blocks = _toBlocks(currentAnswer);
    items.add(_FaqItem(question: currentQuestion!.trim(), blocks: blocks));
    currentQuestion = null;
    currentAnswer.clear();
  }

  for (final raw in lines) {
    final line = raw.trimRight();
    if (line.startsWith('# ')) {
      continue;
    }
    if (line.startsWith('## ')) {
      if (currentQuestion != null) {
        flushCurrent();
      } else {
        currentAnswer.clear();
      }
      currentQuestion = line.substring(3).trim();
      continue;
    }
    currentAnswer.add(line);
  }
  flushCurrent();
  return items;
}

List<_FaqBlock> _toBlocks(List<String> lines) {
  final blocks = <_FaqBlock>[];
  final buffer = <String>[];
  List<String>? listBuf;
  bool ordered = false;

  void flushParagraph() {
    final text = buffer.join('\n').trim();
    if (text.isNotEmpty) {
      blocks.add(_FaqParagraph(text));
    }
    buffer.clear();
  }

  void flushList() {
    if (listBuf != null && listBuf!.isNotEmpty) {
      blocks.add(_FaqList(items: List.of(listBuf!), ordered: ordered));
    }
    listBuf = null;
    ordered = false;
  }

  for (final raw in lines) {
    final line = raw.trimRight();
    if (line.isEmpty) {
      flushParagraph();
      flushList();
      continue;
    }
    final bullet = RegExp(r'^[-•]\s+');
    final orderedMatch = RegExp(r'^(\d+)\.\s+');
    if (bullet.hasMatch(line)) {
      flushParagraph();
      listBuf ??= <String>[];
      ordered = false;
      listBuf!.add(line.replaceFirst(bullet, '').trim());
      continue;
    }
    final m = orderedMatch.firstMatch(line);
    if (m != null) {
      flushParagraph();
      listBuf ??= <String>[];
      ordered = true;
      listBuf!.add(line.replaceFirst(orderedMatch, '').trim());
      continue;
    }
    if (listBuf != null) {
      flushList();
    }
    buffer.add(line);
  }

  flushParagraph();
  flushList();
  return blocks;
}
