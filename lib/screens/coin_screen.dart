import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_crypto_bezzar/data/constant/constants.dart';

import '../data/model/crypto.dart';

class CoinScreen extends StatefulWidget {
  CoinScreen({Key? key, this.coins}) : super(key: key);
  List<Coin>? coins;
  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  List<Coin>? coins;
  bool loadingTextVisibility = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coins = widget.coins;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'کریپتو بازار',
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: blackColor,
      ),
      backgroundColor: blackColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  onChanged: (value) {
                    _filterCoins(value);
                  },
                  decoration: InputDecoration(
                      hintText: "!اسم رمز ارز معتبر خود را سرچ کنید ",
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: greenColor),
                ),
              ),
            ),
            Visibility(
              visible: loadingTextVisibility,
              child: Text(
                '...در حال آپدیت اطلاعات رمز ارزها',
                style: TextStyle(color: greenColor),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  List<Coin> freshData = await _getData();
                  setState(() {
                    coins = freshData;
                  });
                },
                child: ListView.builder(
                  itemCount: coins!.length,
                  itemBuilder: (context, index) =>
                      _getListTileItems(coins![index]),
                ),
                backgroundColor: greenColor,
                color: blackColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List<Coin>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');

    List<Coin> coins = response.data['data']
        .map<Coin>((jsonMapObject) => Coin.fromMapJson(jsonMapObject))
        .toList();
    return coins;
  }

  Widget _getListTileItems(Coin coin) {
    return ListTile(
      leading: SizedBox(
        width: 30.0,
        child: Center(
          child: Text(
            coin.rank.toString(),
            style: TextStyle(color: grayColor),
          ),
        ),
      ),
      title: Text(
        coin.name,
        style: TextStyle(color: greenColor),
      ),
      subtitle: Text(
        coin.symbol,
        style: TextStyle(color: grayColor),
      ),
      trailing: SizedBox(
        width: 130.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  coin.priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: grayColor, fontSize: 18.0),
                ),
                Text(
                  coin.changePercent24Hr.toStringAsFixed(2),
                  style: TextStyle(
                      color: _getChangeTextColor(coin.changePercent24Hr)),
                ),
              ],
            ),
            SizedBox(
              width: 40.0,
              child: Center(
                child: _getTrendingIcon(coin.changePercent24Hr),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getTrendingIcon(double changePercent) {
    return changePercent <= 0
        ? Icon(
            Icons.trending_down,
            size: 24.0,
            color: redColor,
          )
        : Icon(
            Icons.trending_up,
            size: 24.0,
            color: greenColor,
          );
  }

  Color _getChangeTextColor(double changePercent) {
    return changePercent <= 0 ? redColor : greenColor;
  }

  Future<void> _filterCoins(String coinName) async {
    List<Coin> searchedCoinNameList = [];
    if (coinName.isEmpty) {
      setState(() {
        loadingTextVisibility = true;
      });
      var result = await _getData();
      setState(() {
        coins = result;
        loadingTextVisibility = false;
      });
      return;
    }
    searchedCoinNameList = coins!.where((element) {
      return element.name.toLowerCase().contains(coinName.toLowerCase());
    }).toList();

    setState(() {
      coins = searchedCoinNameList;
    });
  }
}
