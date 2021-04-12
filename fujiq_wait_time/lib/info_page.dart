import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:fujiqwaittime/web_detail.dart';
import 'package:app_review/app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:android_intent/android_intent.dart';
import 'package:in_app_review/in_app_review.dart';

class InfoPage extends StatelessWidget {
  final List<Widget> lists = getListWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("情報")),
      body: Container(
          child: ListView.builder(
        itemCount: lists.length,
        itemBuilder: (context, int index) {
          return lists[index];
        },
      )),
    );
  }

  static List<Widget> getListWidgets() {
    if (Platform.isIOS) {
      return [AttractionWidget(), ShareWidget(), IosAppWidget()];
    }
    if (Platform.isAndroid) {
      return [AttractionWidget(), ShareWidget(), AndroidAppWidget()];
    }
    return [];
  }
}

_launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

class AttractionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          height: 40,
          child: Text(
            'お知らせ',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.calendar_today,
              color: Colors.redAccent,
            ),
            title: const Text('本日の運行状況'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebDetail(
                      'https://www.fujiq.jp/schedule/today/', '本日の運行状況'),
                ),
              );
            },
          ),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.fastfood,
              color: Colors.green,
            ),
            title: const Text('フード＆レストラン'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebDetail(
                      'https://www.fujiq.jp/restaurant/?category-area=highland',
                      'フード＆レストラン'),
                ),
              );
            },
          ),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.card_giftcard,
              color: Colors.orange,
            ),
            title: Text('チケット'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WebDetail('https://www.fujiq.jp/ticket/', 'チケット'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class IosAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          height: 40,
          child: Text(
            'アプリ',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.train,
              color: Colors.grey,
            ),
            title: const Text(''),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              if (Platform.isIOS) {
                _launchUrl('');
              }
            },
          ),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.map,
              color: Colors.grey,
            ),
            title: const Text(''),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              if (Platform.isIOS) {
                _launchUrl('');
              }
            },
          ),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.traffic,
              color: Colors.grey,
            ),
            title: const Text(''),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              if (Platform.isIOS) {
                _launchUrl('');
              }
            },
          ),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.fastfood,
              color: Colors.grey,
            ),
            title: const Text(''),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              if (Platform.isIOS) {
                _launchUrl('');
              }
            },
          ),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.chat,
              color: Colors.grey,
            ),
            title: const Text(''),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              if (Platform.isIOS) {
                _launchUrl('');
              }
            },
          ),
        ),
      ],
    );
  }
}

class AndroidAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          height: 40,
          child: Text(
            'アプリ',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.map,
              color: Colors.grey,
            ),
            title: const Text(''),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              if (Platform.isAndroid) {
                _launchUrl(
                    '');
              }
            },
          ),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.map,
              color: Colors.grey,
            ),
            title: const Text(''),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              if (Platform.isAndroid) {
                _launchUrl(
                    '');
              }
            },
          ),
        ),
      ],
    );
  }
}

class ShareWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          height: 40,
          child: Text(
            'シェア',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.share,
              color: Colors.indigoAccent,
            ),
            title: const Text('アプリをシェアする'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              if (Platform.isIOS) {
                Share.share(
                    '');
              } else if (Platform.isAndroid) {
                Share.share(
                    '');
              }
            },
          ),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.star,
              color: Colors.orange,
            ),
            title: const Text('アプリをレビューする'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () async {
              if (Platform.isIOS) {
                AppReview.requestReview.then((onValue) {
                  print(onValue);
                });
              } else if (Platform.isAndroid) {
                AndroidIntent intent = AndroidIntent(
                  action: 'action_view',
                  data: '',
                );
                await intent.launch();
              }
            },
          ),
        ),
      ],
    );
  }
}
