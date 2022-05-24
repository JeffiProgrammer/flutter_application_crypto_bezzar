class Coin {
  String id;
  String name;
  String symbol;
  double changePercent24Hr;
  double priceUsd;
  double marketCapUsd;
  int rank;

  Coin(
    this.id,
    this.name,
    this.symbol,
    this.changePercent24Hr,
    this.priceUsd,
    this.marketCapUsd,
    this.rank,
  );

  factory Coin.fromMapJson(Map<String, dynamic> jsonMapObject) {
    return Coin(
      jsonMapObject['id'],
      jsonMapObject['name'],
      jsonMapObject['symbol'],
      double.parse(jsonMapObject['changePercent24Hr']),
      double.parse(jsonMapObject['priceUsd']),
      double.parse(jsonMapObject['marketCapUsd']),
      int.parse(jsonMapObject['rank']),
    );
  }
}
