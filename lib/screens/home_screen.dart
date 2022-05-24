import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_crypto_bezzar/data/model/crypto.dart';
import 'package:flutter_application_crypto_bezzar/screens/coin_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('images/logo.png')),
            SpinKitWave(
              color: Colors.white,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');

    List<Coin> coins = response.data['data']
        .map<Coin>((jsonMapObject) => Coin.fromMapJson(jsonMapObject))
        .toList();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CoinScreen(coins: coins),
        ));
  }
}
