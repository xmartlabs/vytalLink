import 'package:flutter/material.dart';

/// Renders a string that may contain <b>…</b> tags using a RichText with
/// bold styling applied to the enclosed segments.
class BoldTagText extends StatelessWidget {
  final String text;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const BoldTagText({
    required this.text,
    this.baseStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final base = baseStyle ?? const TextStyle();
    final bold = base.copyWith(fontWeight: FontWeight.w700);
    final spans = buildBoldTagSpans(text, base, bold);
    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
      text: TextSpan(children: spans, style: base),
    );
  }

  static List<TextSpan> buildBoldTagSpans(
    String source,
    TextStyle base,
    TextStyle bold,
  ) {
    final spans = <TextSpan>[];
    int index = 0;
    while (index < source.length) {
      final start = source.indexOf('<b>', index);
      if (start == -1) {
        spans.add(TextSpan(text: source.substring(index), style: base));
        break;
      }
      if (start > index) {
        spans.add(TextSpan(text: source.substring(index, start), style: base));
      }
      final end = source.indexOf('</b>', start + 3);
      if (end == -1) {
        spans.add(TextSpan(text: source.substring(start), style: base));
        break;
      }
      spans.add(TextSpan(text: source.substring(start + 3, end), style: bold));
      index = end + 4;
    }
    return spans;
  }
}
