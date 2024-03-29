import 'dart:io';

import 'package:bioplus/widgets/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {
  final String url, title;
  final ValueChanged<NavigationRequest>? onNavigationRequest;

  // ignore: use_key_in_widget_constructors
  const Webview({required this.url, this.title = '', this.onNavigationRequest});
  @override
  WebviewState createState() => WebviewState();
}

class WebviewState extends State<Webview> {
  int position = 1;
  // double _progress = 0;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        // leadingIsArrowBack: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey[800],
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.grey.shade900,
          ),
        ),
      ),
      body: IndexedStack(
        index: position,
        children: [
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            onWebViewCreated: onWebViewCreated,
            onProgress: onProgress,
            onPageStarted: onPageStarted,
            onPageFinished: onPageFinished,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https:')) {
                final success = request.url == 'https://google.com/';
                final error = request.url == 'https://youtube.com/';
                if (success) {
                  Get.back();
                  DialogService.showDialog(
                    child: SuccessDialog(
                      onTap: Get.back,
                      message: 'Payment Successful',
                    ),
                  );
                }

                if (error) {
                  Get.back();
                  DialogService.showDialog(
                    child: SuccessDialog(
                      onTap: Get.back,
                      message: 'Payment Failed',
                    ),
                  );
                }
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
          ),
          LinearProgressIndicator(
            color: context.theme.primaryColor,
          ),
        ],
      ),
    );
  }

  void onWebViewCreated(WebViewController controller) {}

  void onPageStarted(String value) {
    debugPrint(value);
    setState(() {
      position = 0;
    });
  }

  void onPageFinished(String value) {
    debugPrint(value);
    setState(() {
      position = 0;
    });
  }

  void onProgress(int progress) {
    // _progress = progress.toDouble();
    // log(progress.toString());
    // setState(() {});
  }
}
