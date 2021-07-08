import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebView extends StatefulWidget {
  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse("https://kreatryx.com")),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              // debuggingEnabled: true,
            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            webView = controller;
          },
          onLoadStart: (InAppWebViewController controller, Uri url) {},
          onLoadStop: (InAppWebViewController controller, Uri url) {},
        ),
      ),
    );
  }
}
