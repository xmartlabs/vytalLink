import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class WebPageScreen extends StatelessWidget {
  const WebPageScreen({required this.url, super.key, this.title});

  final String url;
  final String? title;

  @override
  Widget build(BuildContext context) => _WebPageContentScreen(
        url: url,
        title: title,
      );
}

class _WebPageContentScreen extends StatefulWidget {
  const _WebPageContentScreen({
    required this.url,
    super.key,
    this.title,
  });

  final String url;
  final String? title;

  @override
  State<_WebPageContentScreen> createState() => _WebPageScreenState();
}

class _WebPageScreenState extends State<_WebPageContentScreen> {
  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) => setState(() => _progress = progress),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? ''),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => _goBackAction(context),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2),
            child: _progress > 0 && _progress < 100
                ? LinearProgressIndicator(value: _progress / 100)
                : const SizedBox(height: 2),
          ),
        ),
        body: SafeArea(
          child: WebViewWidget(controller: _controller),
        ),
      );

  Future<void> _goBackAction(BuildContext context) async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    } else {
      if (context.mounted) await context.router.maybePop();
    }
  }
}
