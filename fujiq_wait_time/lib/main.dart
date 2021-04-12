import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fujiqwaittime/admob_service.dart';
import 'package:fujiqwaittime/attraction.dart';
import 'package:fujiqwaittime/attraction_card.dart';
import 'package:ncmb/ncmb.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'info_page.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'dart:io';
import 'package:app_review/app_review.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

const ApplicationId =
    "";
const ClientKey =
    "";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  _MyHomePageState();

  NCMB ncmb = NCMB(ApplicationId, ClientKey);
  List<Attraction> attractions = [];

  bool isLoading = true;
  bool isError = false;

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  Future<void> refresh() async {
    setState(() {
      isError = false;
      isLoading = true;
    });
    await Future.sync(() {
      searchAttractions();
    });
    await _interstitialAd?.show();
  }

  Future<void> searchAttractions() async {
    attractions.clear();
    var query = ncmb.Query('Attraction');
    try {
      var response = await query.fetchAll();
      for (int i = 0; i < response.length; i++) {
        var item = response[i];
        var attraction = Attraction(
          item.get('name'),
          item.get('price'),
          item.get('time'),
          item.get('thumbnail'),
          item.get('url'),
        );
        attractions.add(attraction);
      }
      setState(() {
        isError = false;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');
    await prefs.setInt('counter', counter);
  }

  Future<int> _getPrefCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getInt('counter') ?? 0);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      print('inactive');
    } else if (state == AppLifecycleState.resumed) {
      print('resumed');
      _incrementCounter();
      _getPrefCount().then((value) async {
        if (value == 3 || value == 6 || value == 9) {
          if (Platform.isIOS) {
            AppReview.requestReview.then((onValue) {
              print(onValue);
            });
          } else {
            final InAppReview inAppReview = InAppReview.instance;
            if (await inAppReview.isAvailable()) {
              inAppReview.requestReview();
            }
          }
        }
      });
    } else if (state == AppLifecycleState.paused) {
      print('paused');
    }
  }

  @override
  void initState() {
    super.initState();
    searchAttractions();
    setupAds();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildCreateListView(),
          _buildProgressIndicator(),
          _buildNetworkError(),
        ],
      ),
    );
  }

  void setupAds() {
    WidgetsFlutterBinding.ensureInitialized();
    Admob.initialize();
    FirebaseAdMob.instance.initialize(appId: AdMobService().getAppId());
    if (_interstitialAd == null) {
      _interstitialAd = createInterstitialAd()..load();
    }
  }

  Widget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.info_outline),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return InfoPage();
                },
                fullscreenDialog: true),
          );
        },
      ),
      title: const Text('アトラクション'),
    );
  }

  Widget _buildCreateListView() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Column(
        children: <Widget>[
          AdmobBanner(
            adUnitId: AdMobService().getBannerAdUnitId(),
            adSize: AdmobBannerSize.BANNER,
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: attractions.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: AttractionCard(
                      attractions[index],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildNetworkError() {
    if (isError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'インターネットの接続に失敗しました\n電波の良い場所でアプリを利用してください',
              textAlign: TextAlign.center,
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: RaisedButton(
                child: const Text('データを取得する'),
                onPressed: () {
                  searchAttractions();
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: AdMobService().getInterstitialAdUnitId(),
      targetingInfo: null,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }
}
