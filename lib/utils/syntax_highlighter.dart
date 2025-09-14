import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:highlight/highlight.dart' as hi;

class AppSyntaxHighlighter extends SyntaxHighlighter {
  AppSyntaxHighlighter(this._theme);
  final TextTheme _theme;

  @override
  TextSpan format(String source, {String? language}) {
    final result = hi.highlight.parse(source, language: language, autoDetection: true);
    final children = <TextSpan>[];
    for (final node in result.nodes ?? <hi.Node>[]) {
      if (node.value != null) {
        children.add(TextSpan(text: node.value));
      } else if (node.children != null) {
        final style = _styleFor(node.className);
        children.add(TextSpan(style: style, children: _textSpans(node.children!)));
      }
    }
    return TextSpan(style: TextStyle(fontFamily: 'monospace', fontSize: _theme.bodySmall?.fontSize ?? 12), children: children);
  }

  List<TextSpan> _textSpans(List<hi.Node> nodes) {
    final out = <TextSpan>[];
    for (final node in nodes) {
      if (node.value != null) {
        out.add(TextSpan(text: node.value));
      } else if (node.children != null) {
        final style = _styleFor(node.className);
        out.add(TextSpan(style: style, children: _textSpans(node.children!)));
      }
    }
    return out;
  }

  TextStyle? _styleFor(String? className) {
    switch (className) {
      case 'keyword':
      case 'built_in':
        return TextStyle(color: Colors.purple.shade400, fontWeight: FontWeight.w600);
      case 'string':
      case 'title':
        return TextStyle(color: Colors.green.shade600);
      case 'number':
      case 'literal':
        return TextStyle(color: Colors.orange.shade700);
      case 'comment':
        return TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic);
      case 'type':
      case 'class':
        return TextStyle(color: Colors.blue.shade600);
      case 'attr':
      case 'params':
        return TextStyle(color: Colors.teal.shade600);
      default:
        return null;
    }
  }
}
