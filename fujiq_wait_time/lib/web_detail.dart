import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebDetail extends StatefulWidget {
  final String url;
  final String title;
  WebDetail(this.url, this.title);

  @override
  createState() => WebDetailState(this.url,this.title);
}

class WebDetailState extends State < WebDetail > {
  var url;
  var title;
  WebDetailState(this.url,this.title);

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Stack(
          children: <Widget>[
            _buildWebView(),
            _buildProgressIndicator(),
          ],
        ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(this.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () async {
            if (await canLaunch(url)) {
              await launch(url);
            }
          },
        ),
      ],
    );
  }

  Widget _buildWebView() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: this.url,
      onPageFinished: (String url) {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  Widget _buildProgressIndicator() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return SizedBox.shrink();
    }
  }

}