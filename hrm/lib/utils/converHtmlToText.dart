import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;

String extractCleanText(String html) {
  final document = html_parser.parse(html);
  final body = document.body;

  if (body == null) return '';

  // Lấy tất cả các node text, bỏ qua node rỗng
  final buffer = StringBuffer();
  void walk(html_dom.Node node) {
    if (node.nodeType == html_dom.Node.TEXT_NODE) {
      final text = node.text?.trim();
      if (text != null && text.isNotEmpty) buffer.writeln(text);
    }
    node.nodes.forEach(walk);
  }

  walk(body);
  return buffer.toString().trim();
}
